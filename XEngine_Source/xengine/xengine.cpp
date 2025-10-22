#include <stdio.h>
#include <stdlib.h>
#include <opencv4/opencv2/opencv.hpp>
#include <opencv4/opencv2/freetype.hpp>
int main()
{
	cv::Mat m_MatImage = cv::imread("D:\\Input\\1.png", cv::IMREAD_UNCHANGED);
	if (m_MatImage.empty())
	{
		return -1;
	}
	cv::resize(m_MatImage, m_MatImage, cv::Size(), 1.0, 1.0);
	cv::imwrite("D:\\Input\\out.png", m_MatImage);
	return 0;
}