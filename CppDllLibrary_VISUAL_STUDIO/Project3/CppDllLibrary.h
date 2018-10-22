#pragma once
class CppDllLibrary {

public:
	__declspec(dllexport) void convertToNegative(int** pixels, int width, int hight);
};