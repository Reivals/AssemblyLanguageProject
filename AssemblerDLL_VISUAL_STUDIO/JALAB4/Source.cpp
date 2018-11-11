#include <iostream>

double RadToDegNMEACpp(double dRad, bool bSSE2);

extern "C" double _fastcall RadToDegAsm(double rad);
extern "C" bool _fastcall CpuIdAsm();

int main() {
			
	std::cout << "MMX + SSE + SSE2 : " << std::boolalpha << CpuIdAsm() << std::endl;
	if (CpuIdAsm() == false)
		return 0;
	std::cout.precision(20);
	for (float f = 0.; f < 3.14159 * 3; f += 0.5) {
		std::cout << f << " rad  =\t(asm) " << RadToDegAsm(f) << std::endl;
		std::cout << "\t\t(cpp) " << RadToDegNMEACpp(f, true) << std::endl << std::endl;
	}
	std::cin.get();

	return 0;
}