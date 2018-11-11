
.DATA
count QWORD 0
whichArray QWORD 0
functionTable QWORD 0
height QWORD 0
arrayWidth QWORD 0

.CODE
_DllMainCRTStartup PROC hInstDLL:DWORD, reason:DWORD, reserved1: DWORD
	mov	eax, 1 
	ret
_DllMainCRTSTARTUP ENDP


Java_model_AssemblerDllLibrary_convertToNegative proc

				LOCAL env:QWORD
				LOCAL image:QWORD
				LOCAL body:QWORD
				LOCAL singleArray:QWORD
				LOCAL alfa:DWORD
				LOCAL funTable:QWORD
				LOCAL red:DWORD
				LOCAL green:DWORD
				LOCAL blue:DWORD
				LOCAL pixel:DWORD

				;KOLEJNOSC wywo³ywania funkcji JNI 
				;1) rdx 
				;2) rcx
				;3) r8
				;4) r9
				;5+) shadow space


				mov env,rcx ; get JNIEnv variable
				mov image,r8 ; get jobjectArray variable
				mov arrayWidth, r9 ; get width of image
				mov rbx, QWORD PTR[rbp + 48] ; get height of image
				mov height, rbx ; 5th
				mov rax, [rcx]  ; get location of JNI function table
				mov functionTable, rax

outerLoop:
				mov rcx, env
				mov rdx, image
				mov r8, count
				mov rax, functionTable
				call QWORD PTR[rax + 173 * 8]
				mov rdx, rax
				mov singleArray, rax
				mov rcx, env
				mov r8, 0
				mov r10, functionTable
				call QWORD PTR[r10 + 187 * 8]
				mov r11, rax ; saved value where i should save new pixel
				mov rcx,arrayWidth


				xor r9, r9
chunkOfMemory:	mov ebx, DWORD PTR[r11 + r9] ;java int - 4B = 32b so DWORD

				;ALFA
				mov     pixel, ebx
				shr     pixel, 24
				and		pixel, 255
				mov     eax, pixel
				mov		alfa, eax


				;GREEN
				mov pixel, ebx
				shr pixel, 8
				and pixel, 255
				mov eax, pixel
				mov green, eax

				;RED
				mov pixel, ebx
				shr pixel, 16
				and pixel, 255
				mov eax, pixel
				mov red, eax

				;BLUE
				mov pixel, ebx
				and pixel, 255
				mov eax, pixel
				mov blue, eax

				mov     eax, 255
				sub     eax, red
				mov     red, eax
				mov     eax, 255
				sub     eax, green
				mov     green, eax
				mov     eax, 255
				sub     eax, blue
				mov     blue, eax


				;COMBINE RED GREEN BLUE INTO PIXEL
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

				ret ; return to java

Java_model_AssemblerDllLibrary_convertToNegative endp


Java_model_CDllLibrary_convertToSepia proc

Java_model_CDllLibrary_convertToSepia endp

END
;-------------------------------------------------------------------------