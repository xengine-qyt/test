#include <sched.h>
#include <unistd.h>
#include <sys/types.h>
#include <android/log.h>

void main() {
	cpu_set_t mask;
	CPU_ZERO(&mask);

	// 假设大核是 CPU 7 (具体需要根据设备拓扑判断)
	CPU_SET(7, &mask);

	pid_t pid = gettid(); // 获取当前线程ID

	// 设置亲和性
	if (sched_setaffinity(pid, sizeof(mask), &mask) == -1) {
		__android_log_print(ANDROID_LOG_ERROR, "Affinity", "Failed to set affinity");
	}
	else {
		__android_log_print(ANDROID_LOG_INFO, "Affinity", "Successfully bound to core 7");
	}
}