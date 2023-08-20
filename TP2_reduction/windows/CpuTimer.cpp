#include "CpuTimer.h"

// Initialize the resolution of the timer
LARGE_INTEGER CpuTimer::m_freq = (QueryPerformanceFrequency(&CpuTimer::m_freq), CpuTimer::m_freq);

// Calculate the overhead of the timer
LONGLONG CpuTimer::m_overhead = CpuTimer::GetOverhead();