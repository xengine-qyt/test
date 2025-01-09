#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavdevice/avdevice.h>
#include <libavfilter/avfilter.h>
#include <libavfilter/buffersrc.h>
#include <libavfilter/buffersink.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libavutil/channel_layout.h>	
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}

int main()
{
	AVCodecContext* codec_context = NULL;
	const AVCodec* codec = NULL;
	AVFormatContext* format_context = NULL;
	AVStream* audio_stream = NULL;
	AVFrame* frame = NULL;
	AVPacket* pkt = NULL;
	FILE* input_file = NULL;
	int ret;
	int64_t next_pts = 0;

	// Open input file
	const char* input_filename = "D:\\audio\\b.pcm";
	const char* output_filename = "D:\\audio\\input.mp4";
	input_file = fopen(input_filename, "rb");
	if (!input_file) {
		fprintf(stderr, "Could not open input file\n");
		exit(1);
	}

	// Find the AAC encoder
	codec = avcodec_find_encoder_by_name("libfdk_aac");
	if (!codec) {
		fprintf(stderr, "Codec not found\n");
		exit(1);
	}

	// Allocate AVFormatContext for MP4 output
	avformat_alloc_output_context2(&format_context, NULL, NULL, output_filename);
	if (!format_context) {
		fprintf(stderr, "Could not allocate output context\n");
		exit(1);
	}

	// Add audio stream to the output file
	audio_stream = avformat_new_stream(format_context, codec);
	if (!audio_stream) {
		fprintf(stderr, "Could not allocate stream\n");
		exit(1);
	}

	codec_context = avcodec_alloc_context3(codec);
	if (!codec_context) {
		fprintf(stderr, "Could not allocate audio codec context\n");
		exit(1);
	}
	audio_stream->codecpar->frame_size = codec_context->frame_size = 1024;

	// Set codec parameters
	codec_context->sample_fmt = AV_SAMPLE_FMT_S16;
	codec_context->sample_rate = 44100;
	codec_context->bit_rate = 128000;
	codec_context->rc_buffer_size = codec_context->bit_rate;
	codec_context->rc_min_rate = codec_context->bit_rate;
	codec_context->rc_max_rate = codec_context->bit_rate;
	av_channel_layout_default(&codec_context->ch_layout, 2);
	
	// Copy settings to stream
	ret = avcodec_parameters_from_context(audio_stream->codecpar, codec_context);
	if (ret < 0) {
		fprintf(stderr, "Failed to copy codec parameters to stream\n");
		exit(1);
	}
	// Open codec
	if (avcodec_open2(codec_context, codec, NULL) < 0) {
		fprintf(stderr, "Could not open codec\n");
		exit(1);
	}

	// Open output file
	if (!(format_context->oformat->flags & AVFMT_NOFILE)) {
		ret = avio_open(&format_context->pb, output_filename, AVIO_FLAG_WRITE);
		if (ret < 0) {
			fprintf(stderr, "Could not open output file '%s'\n", output_filename);
			exit(1);
		}
	}

	// Write file header
	ret = avformat_write_header(format_context, NULL);
	if (ret < 0) {
		fprintf(stderr, "Error occurred when opening output file\n");
		exit(1);
	}

	// Initialize packet and frame
	pkt = av_packet_alloc();
	if (!pkt) {
		fprintf(stderr, "Could not allocate AVPacket\n");
		exit(1);
	}

	frame = av_frame_alloc();
	frame->nb_samples = codec_context->frame_size;
	frame->format = codec_context->sample_fmt;
	frame->ch_layout = codec_context->ch_layout;

	// Allocate the data buffers
	ret = av_frame_get_buffer(frame, 0);
	if (ret < 0) {
		fprintf(stderr, "Could not allocate audio data buffers\n");
		exit(1);
	}

	// Main loop: read from the input file, encode, write to the output file
	while (fread(frame->data[0], 1, frame->linesize[0], input_file) == frame->linesize[0]) {
		frame->pts = next_pts;  // Set PTS for the frame
		next_pts += frame->nb_samples;  // Increment the next PTS
		// Send the frame to the encoder
		if (avcodec_send_frame(codec_context, frame) < 0) {
			fprintf(stderr, "Error sending frame to codec\n");
			exit(1);
		}

		// Get the encoded packet
		while (avcodec_receive_packet(codec_context, pkt) == 0) {
			pkt->pts = pkt->dts = frame->pts;
			av_packet_rescale_ts(pkt, codec_context->time_base, audio_stream->time_base);
			pkt->stream_index = audio_stream->index;
			av_interleaved_write_frame(format_context, pkt);
			av_packet_unref(pkt);
		}
	}

	// Flush the encoder
	avcodec_send_frame(codec_context, NULL);
	while (avcodec_receive_packet(codec_context, pkt) == 0) {
		pkt->pts = pkt->dts = next_pts;
		av_packet_rescale_ts(pkt, codec_context->time_base, audio_stream->time_base);
		pkt->stream_index = audio_stream->index;
		av_interleaved_write_frame(format_context, pkt);
		av_packet_unref(pkt);
		next_pts += pkt->duration;
	}

	// Write file trailer
	av_write_trailer(format_context);

	// Clean up
	fclose(input_file);
	av_frame_free(&frame);
	av_packet_free(&pkt);
	avcodec_free_context(&codec_context);
	avio_closep(&format_context->pb);
	avformat_free_context(format_context);

	return 0;
}