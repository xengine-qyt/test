#include <iostream>
#include <sys/sysctl.h>
#include <unistd.h>

int main() {
    int numCores;
    size_t size = sizeof(numCores);
    sysctlbyname("hw.ncpu", &numCores, &size, NULL, 0);
    std::cout << "Number of CPU cores1: " << numCores << std::endl;

    long numCores2 = sysconf(_SC_NPROCESSORS_ONLN);
    std::cout << "Number of CPU cores2: " << numCores2 << std::endl;
    return 0;
}