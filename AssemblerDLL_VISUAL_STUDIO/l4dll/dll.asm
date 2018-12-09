.DATA
count QWORD 0
whichArray QWORD 0
functionTable QWORD 0
height QWORD 0
arrayWidth QWORD 0
env QWORD 0
image QWORD 0
alfa DWORD 0
singleArray QWORD 0
funTable QWORD 0
red DWORD 0
green DWORD 0
blue DWORD 0
pixel DWORD 0
returnAdress QWORD 0
sepiaIndicator real8 0.0
redMultiplier real8 0.299
greenMultiplier real8 0.587
blueMultiplier real8 0.114
redGrey DWORD 0
greenGrey DWORD 0
blueGrey DWORD 0

.CODE

_DllMainCRTStartup PROC hInstDLL:DWORD, reason:DWORD, reserved1: DWORD
	mov	eax, 1 
	ret
_DllMainCRTSTARTUP ENDP

;Order of passing arguments (integers/pointers) via registers in Windows x64 ABI
				;1) rdx 
				;2) rcx
				;3) r8
				;4) r9
				;5+) shadow space

; Whole specification which was used to communicated with Java JNI module is avaliable under link
; https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html


Java_model_AssemblerDllLibrary_convertToNegative proc

								mov count, 0
								mov env,rcx ; get JNIEnv variable
								mov image,r8 ; get jobjectArray variable
								mov arrayWidth, r9 ; get width of image
								mov rbx, QWORD PTR[rsp + 40] ; get height of image
								mov height, rbx ; 5th
								mov rax, [rcx]  ; get location of JNI function table
								mov functionTable, rax
								pop returnAdress
								pop rax
								pop rax
								pop rax
								pop rax
								pop height ; get height of image


outerLoop:
								mov rcx, env 
								mov rdx, image
								mov r8, count
								mov rax, functionTable
								call QWORD PTR[rax + 173 * 8] ; call GetObjectArrayElement() -> this funtion returns chunkOfMemory which contains row of image table
								mov rdx, rax
								mov singleArray, rax
								mov rcx, env
								mov r8, 0
								mov r10, functionTable
								call QWORD PTR[r10 + 187 * 8] ; call GetIntArrayElements() -> this funtion returns body(single integer) of row returned by GetObjectArrayElement()
								mov r11, rax ; saved value where i should save new pixel
								mov rcx, arrayWidth ; load arrayWith into counter


								xor r9, r9
chunkOfMemory:					mov ebx, DWORD PTR[r11 + r9] ;r9 will indicate now how many bytes we need to pass to get another element

								;Get ALFA property and save it into variable
								mov     pixel, ebx
								shr     pixel, 24
								and		pixel, 255
								mov     eax, pixel
								mov		alfa, eax


								;Get GREEN property and save it into variable
								mov pixel, ebx
								shr pixel, 8
								and pixel, 255
								mov eax, pixel
								mov green, eax

								;Get RED property and save it into variable
								mov pixel, ebx
								shr pixel, 16
								and pixel, 255
								mov eax, pixel
								mov red, eax

								;Get BLUE property and save it into variable
								mov pixel, ebx
								and pixel, 255
								mov eax, pixel
								mov blue, eax


								;Perform	convertion to negative (every part of pixel needs to be substract from 255)
								mov     eax, 255
								sub     eax, red
								mov     red, eax
								mov     eax, 255
								sub     eax, green
								mov     green, eax
								mov     eax, 255
								sub     eax, blue
								mov     blue, eax


								;After changing values of properties save it again to a pixel (convertion needed here)
								mov eax, alfa
								sal eax, 24
								mov edx, eax
								mov eax, red
								sal eax, 16
								mov edx, eax
								mov eax, green
								sal eax, 8
								or eax, edx
								or eax, blue
								add eax, 0FF000000h

								
								mov DWORD PTR[r11+r9], eax ; save new value of pixel to memory location from which I have taken it

								
								add r9, 4 ; move 4 bytes ahead (in java int variable has 4 bytes lenght)
								dec rcx ; decrement counter
								jnz chunkOfMemory ; jum to loop

								; Free memory and copy back changed values
								mov rcx, env  ;  set JNIEnv variable
								mov rdx, singleArray ; single array
								mov r8, r11 ; value recived in rax GetIntArrayElements()
								mov r9, 0    ; set mode 0 for function (copy and realese)
								mov r10, functionTable   ; set function table variable
								call QWORD PTR[r10 + 195 * 8] ; call ReleaseIntArrayElements() -> free buffer allocated and copy back values which i have changed in assembler

								inc count
								mov rbx, height
								cmp rbx, count
								jnz outerLoop ; height loop
								push returnAdress
								ret ; return to java


Java_model_AssemblerDllLibrary_convertToNegative endp


Java_model_AssemblerDllLibrary_convertToSepia proc

								mov count, 0
								mov env,rcx ; get JNIEnv variable
								mov image,r8 ; get jobjectArray variable
								mov arrayWidth, r9 ; get width of image
								mov rbx, QWORD PTR[rsp + 40] ; get height of image
								mov height, rbx ; 5th
								mov rbx, QWORD PTR[rsp +48]
								mov sepiaIndicator, rbx
								mov rax, [rcx]  ; get location of JNI function table
								mov functionTable, rax
								pop returnAdress
								pop rax
								pop rax
								pop rax
								pop rax
								pop height ; tutaj


outerLoop:
								mov rcx, env
								mov rdx, image
								mov r8, count
								mov rax, functionTable
								call QWORD PTR[rax + 173 * 8] ; call GetObjectArrayElement() -> this funtion returns chunkOfMemory which contains row of image table
								mov rdx, rax
								mov singleArray, rax
								mov rcx, env
								mov r8, 0
								mov r10, functionTable
								call QWORD PTR[r10 + 187 * 8] ; call GetIntArrayElements() -> this funtion returns body(single integer) of row returned by GetObjectArrayElement()
								mov r11, rax ; saved value where i should save new pixel
								mov rcx,arrayWidth


								xor r9, r9 ; clear r9
chunkOfMemory:		
								mov ebx, DWORD PTR[r11 + r9] ; get elements from a row (iteration through changing r9)

								;Get ALFA property and save it into variable
								mov pixel, ebx
								shr pixel, 24
								and	pixel, 255
								mov eax, pixel
								mov alfa, eax

								;Get GREEN property and save it into variable
								mov pixel, ebx
								shr pixel, 8
								and pixel, 255
								mov eax, pixel
								mov green, eax

								;Get RED property and save it into variable
								mov pixel, ebx
								shr pixel, 16
								and pixel, 255
								mov eax, pixel
								mov red, eax

								;Get BLUE property and save it into variable
								mov pixel, ebx
								and pixel, 255
								mov eax, pixel
								mov blue, eax

								;**********************************LEGEND*****************************************
								;cvtsi2sd — Convert Doubleword Integer to Scalar Double-Precision Floating-Point Value  *
								;movsd — Move or Merge Scalar Double-Precision Floating-Point Value		64b   				 *
								;mulsd — Multiply Scalar Double-Precision Floating-Point Value											 *
								;movaps — Move Aligned Packed Single-Precision Floating-Point Values		 124b				 *
								;addsd — Add Scalar Double-Precision Floating-Point Values													 *
								;***********************************************************************************
								
								;begin sepia convertion
								cvtsi2sd xmm0, red
								movsd   xmm1, redMultiplier
								mulsd   xmm1, xmm0
								movaps  xmm0, xmm1
								cvtsi2sd xmm1, green
								movsd   xmm2, greenMultiplier
								mulsd   xmm2, xmm1
								movaps  xmm1, xmm2
								addsd   xmm0, xmm1
								cvtsi2sd xmm1, blue
								movsd   xmm2, blueMultiplier
								mulsd   xmm2, xmm1
								movaps  xmm1, xmm2
								addsd   xmm0, xmm1
								cvttsd2si eax, xmm0
								mov     redGrey, eax
								mov     blueGrey, eax
								mov	 greenGrey, eax


								mov edx, 2
								mov rax, sepiaIndicator
								mul edx
								mov edx, redGrey
								add eax, edx
								mov redGrey, eax
								mov rax, sepiaIndicator
								mov edx, greenGrey
								add edx, eax
								mov eax, edx
								mov greenGrey, eax


								;Ifs which are checking if R/G/B is larger than 255

								cmp greenGrey, 255
								jle SHORT greenLargerThan ; short jump if greenGrey > 255
								mov greenGrey, 255
greenLargerThan:
								cmp redGrey, 255
								jle SHORT redLargerThan ; jump if redGrey > 255
								mov redGrey, 255
redLargerThan:
								cmp blueGrey, 255   
								jle SHORT blueLargerThan ; jump if blueGrey > 255
								mov blueGrey, 255
blueLargerThan:

								;After changing values of properties save it again to a pixel (convertion needed here)
								mov eax, alfa
								sal eax, 24
								mov edx, eax
								mov eax, redGrey
								sal eax, 16
								mov edx, eax
								mov eax, greenGrey
								sal eax, 8
								or eax, edx
								or eax, blueGrey
								add eax, 0FF000000h

								
								mov DWORD PTR[r11+r9], eax ; replce old pixel with new pixel

								
								add r9, 4 ; increment counter (widthArray)
								dec rcx
								jnz chunkOfMemory

								; Free memory and copy back changed values
								mov rcx, env  ;  set JNIEnv variable
								mov rdx, singleArray ; single array
								mov r8, r11 ; value recived in rax GetIntArrayElements()
								mov r9, 0    ; set mode 0 for function (copy and realese)
								mov r10, functionTable   ; set function table variable
								call QWORD PTR[r10 + 195 * 8] ; call realese function

								inc count
								mov rbx, height
								cmp rbx, count
								jnz outerLoop ; height loop
								push returnAdress ; get return adress
								ret ; return to java program

Java_model_AssemblerDllLibrary_convertToSepia endp

END
