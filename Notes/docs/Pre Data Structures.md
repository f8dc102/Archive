# Pre Data Structures

Made with ❤️ by 2023245050 정재윤

## Structures

구조체는 여러 데이터형을 묶어 하나의 자료형처럼 다루기 위한 C언어의 자료구조임.

```c
// 구조체 정의
typedef struct {
    char name[20];
    int age;
    double height;
} Person;

// 구조체 변수 선언 및 초기화
Person p = {"Alice", 20, 170.5};
```

### 구조체의 핵심 주의점

- 구조체 크기는 각 멤버들의 합이지만, 메모리 정렬(alignment)이 추가되어 실제 크기가 더 커질 수 있음.

- 구조체 포인터는 ->로 접근.

```c
Person *ptr = &p; // p의 주소를 가리키는 포인터, ptr은 Person* 타입
printf("%s, %d\n", ptr->name, ptr->age);
```

## Dynamic Allocation

Runtime에 메모리를 할당받고 반납하는 방법

```c
int *arr = (int*)malloc(10 * sizeof(int));
if (arr == NULL) {
    printf("메모리 할당 실패\n");
    exit(1);
}

// 사용 후 메모리 해제
free(arr);
```

### 동적 할당의 주요 함수

- malloc(size): 원하는 크기만큼 메모리를 할당하고, 할당한 메모리의 시작 주소를 반환.

- calloc(num, size): 0으로 초기화된 메모리를 할당.

- realloc(ptr, new_size): 할당된 메모리의 크기를 재조정.

```c
// 크기를 두 배로 확장
arr = realloc(arr, 20 * sizeof(int));
if (arr == NULL) {
    printf("Reallocation failed!\n");
    exit(1);
}
```

- free(ptr): 할당받은 메모리를 반환.  

```c
free(arr);
arr = NULL;
```

### 동적 할당의 핵심 주의점

- **메모리 할당 관련 흔한 실수**  
이미 해제된 메모리를 다시 free()하는 것.  
포인터가 가리키는 메모리를 초과 접근하는 것.  
realloc 결과는 기존 포인터와 다른 주소를 반환할 수 있으므로 원래 포인터를 반드시 갱신해야 함.

- 동적 할당한 메모리는 꼭 free()로 반환해야 메모리 누수를 방지할 수 있음.

- 할당 성공 여부는 항상 확인해야 함.

```c
int *arr = malloc(10* sizeof(int));
if (arr == NULL) {
    printf("Memory allocation failed!\n");
    exit(1);
}
```

## 구조체의 심화 (동적 메모리 할당과의 결합)

구조체를 동적으로 할당하는 경우가 많습니다.

```c
typedef struct {
    char name[20];
    int age;
} Person;

Person *p = malloc(sizeof(Person));
strcpy(p->name, "John");
p->age = 30;

free(p); // 꼭 해제해야 함
```

구조체에 포인터 변수를 멤버로 가질 경우 반드시 별도로 메모리 할당 및 해제를 관리해야 함.

```c
typedef struct {
    char *name;
    int age;
} Person;

Person *p = malloc(sizeof(Person));
p->name = malloc(50 * sizeof(char)); // 문자열 공간 별도 할당

strcpy(p->name, "Alice");
p->age = 30;

// 해제 시 역순으로 해제 필요!
free(p->name);
free(p);
```

## Pointers

### 포인터의 진짜 의미

- 포인터는 “주소를 저장하는 변수”.

- 포인터가 가진 값은 어떤 변수의 메모리 주소값.

- 메모리를 직접 다루는 만큼 강력하지만, 잘못 사용하면 프로그램이 쉽게 오류를 일으킬 수 있음.

```c
int num = 10;
int *ptr = &num;  // 포인터 선언 및 초기화

printf("num의 값: %d\n", *ptr); // 포인터를 통해 값 접근
```

### 포인터 연산

포인터는 주소를 저장하므로 덧셈·뺄셈을 통해 메모리 상에서 이동할 수 있음.

```c
printf("%d\n", *(p + 1)); // arr[1]의 값 출력 (2)
```

### 포인터 사용 시 주의점

- 초기화되지 않은 포인터는 사용 금지(쓰레기 값을 가리켜 위험함).

- NULL 포인터 사용을 권장하여 명확하게 초기화.

- 포인터는 범위를 벗어난 주소를 참조하면 위험.

- 포인터는 선언한 타입의 크기만큼 이동.

- 포인터의 크기는 운영체제에 따라 다르지만, 일반적으로 64비트 환경에선 8바이트.

### 포인터와 배열의 관계

```c
int arr[5] = {10, 20, 30, 40, 50};
int *p = arr;  // arr과 &arr[0]은 같은 의미, 시작 주소를 가리킴

printf("%d\n", *(p + 2)); // 30을 출력, arr[2]와 동일
```

- 배열은 곧 첫 원소의 주소. (즉, arr == &arr[0])
- 포인터 연산은 포인터의 자료형 크기만큼 단위 이동.
- 배열 이름은 배열의 첫 번째 요소 주소를 나타냄.

### 포인터와 문자열의 관계

문자열은 항상 마지막에 '\0'(널문자)가 있음.

```c
char str[] = "Hello";
char *p = str;

printf("%c\n", *(p+1));  // 'e' 출력
```

### 이중 포인터의 이해

이중 포인터는 포인터의 주소를 가리키는 포인터.

```c
int value = 10;
int *ptr = &value;
int **pptr = &ptr; // 포인터를 가리키는 포인터(이중 포인터)

printf("%d\n", **pp); // 10 출력
```

### Header Files

헤더 파일(*.h)은 함수 프로토타입과 구조체 정의, 상수, 매크로 등을 포함하여 소스 파일 간 공유하는 데 사용.

```c
// header.h
#ifndef HEADER_H
#define HEADER_H

#define MAX_SIZE 100

typedef struct {
    int id;
    char data[MAX_SIZE];
} Item;

void printItem(Item item);

#endif
```

헤더 파일 중복 방지를 위해 #ifndef ~ #endif를 사용.

매크로 (#ifndef ~ #endif 포함)
매크로는 전처리 과정에서 코드의 일부분을 치환하는 데 사용.

```c
#define PI 3.14159
#define SQUARE(x) ((x)*(x))

헤더 중복 방지를 위한 가드:

#ifndef HEADER_H
#define HEADER_H

// 내용

#endif
```

### 헤더 파일 중복 방지

아래는 중복 방지 매크로를 이용한 기본 구조.

```c
#ifndef PERSON_H
#define PERSON_H

typedef struct {
    char name[20];
    int age;
} Person;

void printPerson(const Person *p);

#endif
```

위 구조는 한 번 이상 헤더가 포함되어도 문제를 일으키지 않음.

## Multiple Source File Structure

여러 소스파일(*.c)과 헤더파일(*.h)로 분리하는 방법.

구조 예시

```shell
project/
├── main.c
├── person.c
└── person.h
```

person.h

```c
#ifndef PERSON_H
#define PERSON_H

typedef struct {
    char name[30];
    int age;
} Person;

void printPerson(Person *p);
```

person.c

```c
#include "person.h"
#include <stdio.h>

void printPerson(const Person *p) {
    printf("Name: %s, Age: %d\n", p->name, p->age);
}
```

헤더파일은 함수 선언만 들어가고, 실제 구현은 소스파일에 들어감.
