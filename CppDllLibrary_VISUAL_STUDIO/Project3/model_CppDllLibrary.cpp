#include "model_CDllLibrary.h"


JNIEXPORT void JNICALL Java_model_CDllLibrary_convertToNegative
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

JNIEXPORT void JNICALL Java_model_CDllLibrary_convertToSepia
(JNIEnv *env, jobject obj, jobjectArray image, jdouble sepiaIndicator) {
	jint *body = nullptr;
	int arrayLenght = env->GetArrayLength(image);
	int lenght, pixel, alfa, red, green, blue;
	for (int i = 0; i<arrayLenght; i++) {
		jintArray singleArray = (jintArray)env->GetObjectArrayElement(image, i);
		lenght = env->GetArrayLength(singleArray);
		body = env->GetIntArrayElements(singleArray, false);
		for (int j = 0; j<lenght; j++) {
			pixel = body[j]; //pobranie pixela z tablicy 
			alfa = (pixel >> 24) & 0xff;  // wyodrebnienie kana³u alfa
			red = (pixel >> 16) & 0xff; // wyodrêbnienie czerwonego
			green = (pixel >> 8) & 0xff; // wyodrêbnienie zielonego
			blue = pixel & 0xff;  // wyodrêbnienie niebieskiego
			red = 0.299*red + 0.587*green + 0.114*blue;  // zamiana skladowej na kolor szary
			green = 0.299*red + 0.587*green + 0.114*blue; // zamiana skladowej na kolor szary
			blue = 0.299*red + 0.587*green + 0.114*blue; // zamiana skladowej na kolor szary
			red = red + 2 * sepiaIndicator; // dodanie zmiennej sterujacej natê¿eniem sepii
			green += sepiaIndicator; // dodanie zmiennej sterujacej natê¿eniem sepii
			if (green > 255) {
				green = 255;
			}
			if (red > 255) {
				red = 255;
			}
			if (blue > 255) {
				blue = 255;
			}

			pixel = (alfa << 24) | (red << 16) | (green << 8) | blue; // zapis sk³adowych do postaci jednego int'a
			body[j] = pixel; // ponowny zapis do tablicy
		}
		env->ReleaseIntArrayElements(singleArray, body, JNI_COMMIT);
	}
}
