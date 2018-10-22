#include "CppDllLibrary.h"
#include "model_CppDllLibrary.h"


JNIEXPORT void JNICALL Java_model_CppDllLibrary_convertToNegative
(JNIEnv *env, jobject obj, jobjectArray image) {
	jint *body = nullptr;
	int arrayLenght = env->GetArrayLength(image);
	int lenght, pixel, alfa, red, green, blue;
	for (int i = 0; i<arrayLenght; i++) {
		jintArray singleArray = (jintArray)env->GetObjectArrayElement(image, i);
		lenght = env->GetArrayLength(singleArray);
		body = env->GetIntArrayElements(singleArray, false);
		for (int j = 0; j<lenght; j++) {
			pixel = body[j];
			alfa = (pixel >> 24) & 0xff;
			red = (pixel >> 16) & 0xff;
			green = (pixel >> 8) & 0xff;
			blue = pixel & 0xff;
			red = 255 - red;
			green = 255 - green;
			blue = 255 - blue;
			pixel = (alfa << 24) | (red << 16) | (green << 8) | blue;
			body[j] = pixel;
		}
		env->ReleaseIntArrayElements(singleArray, body, JNI_COMMIT);
	}
}

JNIEXPORT void JNICALL Java_model_CppDllLibrary_convertToSepia
(JNIEnv *env, jobject obj, jobjectArray image, jdouble sepiaIndicator) {
	jint *body = nullptr;
	int arrayLenght = env->GetArrayLength(image);
	int lenght, pixel, alfa, red, green, blue;
	for (int i = 0; i<arrayLenght; i++) {
		jintArray singleArray = (jintArray)env->GetObjectArrayElement(image, i);
		lenght = env->GetArrayLength(singleArray);
		body = env->GetIntArrayElements(singleArray, false);
		for (int j = 0; j<lenght; j++) {
			pixel = body[j];
			alfa = (pixel >> 24) & 0xff;
			red = (pixel >> 16) & 0xff;
			green = (pixel >> 8) & 0xff;
			blue = pixel & 0xff;
			red = red + 2 * sepiaIndicator;
			green += sepiaIndicator;
			pixel = (alfa << 24) | (red << 16) | (green << 8) | blue;
			body[j] = pixel;
		}
		env->ReleaseIntArrayElements(singleArray, body, JNI_COMMIT);
	}
}
