# 데이터구조론 중간고사 요약

2025년 1학기 데이터구조론 중간고사를 대비해서 요약해두고 정리한 내용이다.

강의자료를 바탕으로 정리했으며, 강의자료에 없는 내용은 추가로 설명을 붙였다.

모두들 중간고사 잘 보길 바란다!

## Table of Contents

- [Basic Concept](#basic-concept)
- [Recursion](#recursion)
- [Array List](#array-list)
- [Linked List](#linked-list)
- [Stack](#stack)
- [Queue](#queue)
- [Deque](#deque)

## Basic Concept

### 추상 자료형

추상 자료형(ADT, Abstract Data Type)은 데이터와 그 데이터에 적용할 수 있는 연산을 정의한 것이다.

ADT는 데이터의 물리적 구현을 숨기고, 데이터의 논리적 구조와 연산을 정의한다.

### 복잡도

알고리즘 복잡도는 시간 복잡도와 공간 복잡도로 나뉜다.

- **시간 복잡도**: 알고리즘이 문제를 해결하는 데 걸리는 시간
- 공간 복잡도: 알고리즘이 문제를 해결하는 데 필요한 메모리 공간

#### 시간 복잡도

데이터 입력의 크기($n$)에 따라 알고리즘의 실행 시간이 어떻게 변하는지를 나타내는 함수이다.

##### Big-O Notation

**최악의 경우**를 나타내는 점근적 표기법이다.

- $T(n)$이 $O(f(n))$이면, 입력 크기 $n$이 충분히 클 때 $T(n)$은 $f(n)$보다 크지 않다.

즉, $O(f(n))$은 알고리즘의 상한(bound)을 나타낸다.

1. 다항식의 경우
    - $T(n)=a_mn^m+a_{m-1}n^{m-1}+\cdots \Rightarrow O(n^m)$ (최고차항만 남긴다)
2. 로그, 지수 함수는 점근적 성질만 고려:
    - $T(n)=\log n \Rightarrow O(\log n)$, $T(n)=2^n \Rightarrow O(2^n)$
3. 핵심 연산이 $O(1)$일 경우, 반복문, 재귀 구조 등에 따라 분석
4. 반복 형태에 따른 시간복잡도:
    - $+1$씩 증가: $O(n)$
    - $\times2$씩 증가: $O(\log n)$
    - 중첩 반복: $O(n^2)$ 등 $\rightarrow$ 반복 횟수 곱셈으로 계산
5. 재귀 호출 형태에 따라:
    - $T(n) = T(n - 1) + O(1)$ $\rightarrow$ $O(n)$
    - $T(n) = T(n / 2) + O(1)$ $\rightarrow$ $O(\log n)$
6. 조건문은 복잡도에 영향 없음 $\rightarrow$ 무시 가능 (조건 검사 자체가 $O(1)$이기 때문)
7. 중첩 루프 $\rightarrow$ **곱셈**하여 계산:
    - $O(n) \times O(n) = O(n^2)$
8. 연속 루프 → 가장 큰 것 기준으로 판단
    - $O(n) + O(n^2) \Rightarrow O(n^2)$

## Recursion

재귀함수는 자기 자신을 호출하는 함수이다.

헷갈릴 수 있는데 재귀함수는 함수 복사본을 호출하는 방식이지, 함수 재진입의 개념이 아니다.

### 피보나치 수열

```txt
0, 1, 1, 2, 3, 5, 8, 13, 21, ...
```

수열의 $n$번째 값 = 수열의 $(n-1)$번째 값 + 수열의 $(n-2)$번째 값 + $\cdots$ $\rightarrow$ 재귀적 호출

#### 피보나치 함수 호출 순서

**Top-Down** 방식으로 호출된다.

```txt
$f(n)$ 호출 (1)
    L $f(n-1)$ 호출 (2)
        L $f(n-2)$ 호출 (3)
            L $f(n-3)$ 호출 (4)
                L $f(n-4)$ 호출 (5)
            L $f(n-4)$ 호출 (6)
        L $f(n-3)$ 호출 (7)
            L $f(n-4)$ 호출 (8)
    L $f(n-2)$ 호출 (9)
        L $f(n-3)$ 호출 (10)
            L $f(n-4)$ 호출 (11)
```

이러한 방식은 중복 호출이 발생하기 때문에 **비효율적**이다.

시간 복잡도는 $O(2^n)$이다.

### 이진 탐색 알고리즘

**정렬된 배열**에서 특정 값을 찾는 알고리즘이다.

이 알고리즘의 핵심은 다음과 같다:

1. **정렬된 배열**의 중간값을 확인
2. 찾는 값이 더 작으면 왼쪽 절반으로 한정, 크면 오른쪽 절반 탐색 $\rightarrow$ 반복
3. 찾는 값이 중간값과 같으면 탐색 종료

시간 복잡도는 $O(\log{n})$이다.

```c
element binarySearch(arr, target, first, last) {
    // 탈출 조건
    if (first > last) {
        return -1; // 찾는 값이 없음
    }

    int mid = (first + last) / 2;

    if (arr[mid] == target) {
        return mid; // 찾는 값의 인덱스 반환
    } else if (arr[mid] > target) {
        return binarySearch(arr, target, first, mid - 1); // 왼쪽 절반 탐색
    } else {
        return binarySearch(arr, target, mid + 1, last); // 오른쪽 절반 탐색
    }
}
```

### 하노이 탑

하노이 탑은 세 개의 기둥과 $n$개의 원판으로 구성된 퍼즐이다.

원판 $n$개를 $A\rightarrow C$로 옮기되, 한번에 하나씩만, 큰 원반은 작은 원반 위에 못 놓는다.

하노이 탑을 해결하기 위한 재귀적 접근은 다음과 같다:

1. 위에 있는 $n-1$개를 $A\rightarrow B$로 옮김
2. $A$에 있는 $n$번째 원판을 $A\rightarrow C$로 옮김
3. $B$에 있는 $n-1$개를 $B\rightarrow C$로 옮김

시간 복잡도는 $O(2^n)$이다.

```c
void hanoi(int n, char from, char tmp, char to) {
    if (n == 1) {
        printf("%c -> %c\n", from, to); // 원판을 옮김
    } else {
        hanoi(n - 1, from, to, tmp); // A -> B
        printf("%c -> %c\n", from, to); // A -> C
        hanoi(n - 1, tmp, from, to); // B -> C
    }
}
```

## Array List

배열 리스트는 물리적 순서와 논리적 순서가 일치하는 선형 자료구조이다.

참고로 배열 인덱스는 $0$부터 시작하므로 **원소의 총 개수**는 $(n+1)$이다.

### 배열 리스트의 구현

배열 리스트는 배열을 이용하여 구현할 수 있다.

삽입, 삭제 연산시 오버헤드가 크고, 메모리 낭비가 발생할 수 있지만, **임의 접근**이 가능하다는 장점이 있다.

#### 배열 리스트 구조체

**데이터 배열**과 **리스트의 길이**를 저장하는 구조체를 정의한다.

```c
typedef int element;
typedef struct {
    element data[MAXIMUM_SIZE]; // 리스트 항목을 저장할 배열 정의
    int length; // 리스트 항목 개수
} ArrayList;
```

#### 배열 리스트 초기화

리스트를 초기화하는 함수는 리스트의 길이를 $0$으로 설정한다.

```c
void init(ArrayList *list) {
    list->length = 0; // 리스트 항목 개수 초기화
}
```

상태를 확인하는 함수도 다음과 같이 정의할 수 있다:

```c
int isFull(ArrayList *list) {
    return list->length == MAXIMUM_SIZE; // 포화상태
}

int isEmpty(ArrayList *list) {
    return list->length == 0; // 비어있음
}
```

#### 배열 리스트 삽입 연산

$n$번째 원소부터 $k$번째 원소까지 $\left(n+1-k\right)$개의 원소 이동

시간 복잡도는 $O(n)$이다. (최악의 경우 $n$개 원소를 모두 이동해야 하므로)

1. 배열이 포화상태인지 검사
2. 삽입 위치가 적합한 범위에 있는지 검사
3. **배열의 끝쪽부터** 삽입할 위치까지 한 칸씩 뒤로 이동
4. 삽입할 원소를 빈 자리에 삽입
5. 리스트 항목 개수 증가

```c
void insert(ArrayList *list, int position, element item) {
    if (isFull(list)) {
        printf("리스트가 포화상태입니다.\n");
        return;
    }

    if (position < 0 || position > list->length) {
        printf("삽입 위치가 잘못되었습니다.\n");
        return;
    }

    for (int i = list->length; i > position; i--) {
        // 아래 코드는 앞의 원소의 자리 -> 뒤의 원소의 자리로 이동하는 것이다.
        // 대입 연산자의 오른쪽 값이 왼쪽에 대입됨을 유의하자.
        list->data[i] = list->data[i - 1]; // 한 칸씩 뒤로 이동
    }
    list->data[position] = item; // 삽입할 원소를 빈 자리에 삽입
    list->length++; // 리스트 항목 개수 증가
}
```

#### 배열 리스트 삭제 연산

$k+1$번째 원소부터 $n$번째 원소까지 $\left(n-k\right)$개의 원소 이동

시간 복잡도는 $O(n)$이다. (최악의 경우 $n$개 원소를 모두 이동해야 하므로)

1. 배열이 빈 상태인지 검사
2. 삭제 위치가 적합한 범위에 있는지 검사
3. 삭제할 원소를 삭제
4. 빈 자리 채움 (삭제한 원소쪽부터 이동)

```c
element delete(ArrayList *list, int position) {
    if (isEmpty(list)) {
        printf("리스트가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }

    if (position < 0 || position >= list->length) {
        printf("삭제 위치가 잘못되었습니다.\n");
        return -1; // 삭제할 원소가 없음
    }

    element item = list->data[position]; // 삭제할 원소 저장

    for (int i = position; i < list->length - 1; i++) {
        // 아래 코드는 뒤의 원소의 자리 -> 앞의 원소의 자리로 이동하는 것이다.
        // 대입 연산자의 오른쪽 값이 왼쪽에 대입됨을 유의하자.
        list->data[i] = list->data[i + 1]; // 한 칸씩 앞으로 이동
    }
    list->length--; // 리스트 항목 개수 감소

    return item; // 삭제한 원소 반환
}
```

### 배열 리스트의 활용

원소가 하나씩 **순서대로** 나열되어 있고, 삽입과 삭제 연산보다는 읽기, 쓰기 연산이 더 많은 경우에 유용하다.

대표적인 예로는 Polynomial(다항식), Matrix(행렬 연산) 등이 있다.

#### 다항식

다항식은 $ax^e$ 형식의 합으로 구성된 식이다.

- $e$: 차수 (exponent)
- $a$: 계수 (coefficient)
- $x$: 변수 (variable)

다항식의 차수는 다항식에서 가장 큰 차수를 가진 항의 차수이다.

상수항을 포함하여 항의 최대 개수는 (다항식의 차수 + 1)이다.

##### 배열 리스트로 구현한 다항식 자료구조

**다항식의 모든 항을 배열에 저장하는 방법**은 매우 쉽게 구현할 수 있지만 공간 낭비가 클 수 있다.

예를 들어, $x^5$의 계수는 0이고 $x^4$의 계수는 0인 경우에도 $x^5$와 $x^4$를 저장해야 한다.

즉, **희소다항식의 경우**에는 차수가 큰 항이 많고, 계수가 0인 항이 많을 수 있다.

대신, **다항식의 계수가 0이 아닌 항만 저장하는 방법**을 사용한다.

###### 배열 리스트로 구현한 다항식 구조체

아래의 구조체로 여러 항의 다항식을 표현할 수 있다.

```c
typedef struct {
    float coef; // 계수
    int exp; // 차수
} PolyTerm;

typedef struct {
    PolyTerm terms[MAX_TERMS]; // 다항식의 항을 저장할 배열
    int length; // 다항식의 항 개수
} Polynomial;
```

###### 배열 리스트로 구현한 다항식 덧셈 연산

다항식의 덧셈 연산은 두 개의 다항식을 더하는 연산이다.

강의 자료에는 의사코드만 있지만 C로 구현한 코드는 다음과 같다.

```c
// 결과 다항식을 0으로 초기화하는 함수
Polynomial zeroPoly() {
    Polynomial p;
    p.length = 0;
    return p;
}

Polynomial addPoly(Polynomial p1, Polynomial p2) {
    Polynomial result = zeroPoly();
    int i = 0, j = 0, k = 0;

    // 두 다항식의 길이만큼 반복
    while (i < p1.length && j < p2.length) {
        // 차수가 같은 경우
        if (p1.terms[i].exp == p2.terms[j].exp) {
            // 계수를 더함
            float sumCoef = p1.terms[i].coef + p2.terms[j].coef;
            // 계수가 0이 아닌 경우에만 결과에 저장
            if (sumCoef != 0) { // 0 계수는 저장하지 않음
                result.terms[k].coef = sumCoef;
                result.terms[k].exp = p1.terms[i].exp;
                k++;
            }
            // 다음 항으로 이동
            i++; j++;
        // 차수가 p1이 더 큰 경우
        } else if (p1.terms[i].exp > p2.terms[j].exp) {
            // p1의 항을 결과에 저장
            result.terms[k++] = p1.terms[i++];
        // 차수가 p2가 더 큰 경우
        } else {
            // p2의 항을 결과에 저장
            result.terms[k++] = p2.terms[j++];
        }
    }

    // 남은 항을 결과에 저장
    while (i < p1.length) {
        result.terms[k++] = p1.terms[i++];
    }

    // 남은 항을 결과에 저장
    while (j < p2.length) {
        result.terms[k++] = p2.terms[j++];
    }

    // 결과 다항식의 길이를 설정
    result.length = k;
    return result;
}
```

#### 희소행렬

**희소행렬**은 0이 아닌 요소가 전체 요소의 5% 미만인 행렬이다.

희소행렬을 구현하는 방법도 2가지가 소개되고 있다:

1. 모든 요소를 2차원 배열에 저장하는 방법
2. 0이 아닌 요소들만 배열에 저장하는 방법

2차원 배열을 이용하여 배열의 **전체 요소를 저장하는 방법**은 메모리 낭비가 크고, 행렬의 크기가 커질수록 비효율적이다.

대신, **희소행렬**을 구현하기 위해 0이 아닌 요소들만 저장하는 방법을 사용한다.

##### 희소행렬 구현

1. 0이 아닌 요소들만 추출하여 [행번호, 열번호, 값]의 형태로 저장
2. 추출한 순서쌍을 2차원 배열에 행으로 저장
3. 원래의 행렬에 대한 정보를 0번 행에 저장 [행개수, 열개수, 0이 아닌 원소 수]를 0번 행에 저장

아래 구조체는 강의자료에는 없지만 참고용으로 추가했다.

```c
typedef struct {
    int row; // 행 번호
    int col; // 열 번호
    int value; // 값
} SparseMatrix;

typedef struct {
    SparseMatrix data[MAX_TERMS]; // 희소행렬의 요소를 저장할 배열
    int rows; // 행 개수
    int cols; // 열 개수
    int terms; // 비율
} SparseMatrix;
```

## Linked List

연결 리스트는 자료의 논리적인 순서와 물리적인 순서가 일치하지 않는 선형 자료구조이다.

배열과 달리 메모리상 연속된 공간을 사용할 필요가 없으므로, 공간의 낭비가 적고 삽입과 삭제가 용이하다는 장점이 있다.

각 노드(Node)는 다음 노드에 대한 포인터(링크)와 데이터를 포함하며, 필요한 시점에 동적 메모리 할당으로 생성된다.

연결 리스트는 구조에 따라 다음의 세 가지로 나뉜다:

1. 단일 연결 리스트 (Singly Linked List)
2. 원형 연결 리스트 (Circular Linked List)
3. 이중 연결 리스트 (Doubly Linked List)

### 단일 연결 리스트

- 각 노드는 데이터와 다음 노드에 대한 포인터(link)를 가진다.
- 한 방향(앞 → 뒤)으로만 탐색 가능하며, 동적 메모리 할당을 통해 필요할 때마다 노드를 생성한다.
- 삽입/삭제가 빠르지만, 임의 접근(indexing)은 느리다.

> HEAD -> [1] -> [2] -> [3] -> [4] -> NULL

#### 단일 연결 리스트 구조체

단일 연결 리스트는 노드와 리스트를 정의하는 두 구조체로 구성된다.

```c
// 데이터 타입 정의
typedef int element;

// 노드 구조체: 각 노드는 데이터를 저장하고 다음 노드를 가리킨다.
typedef struct SinglyLinkedListNode {
    element data; // 데이터
    struct SinglyLinkedListNode *link; // 다음 노드에 대한 포인터
} SinglyLinkedListNode;

// 리스트 구조체: 리스트 전체를 관리하는 구조체
typedef struct {
    SinglyLinkedListNode *head; // 첫 번째 노드에 대한 포인터
    int length; // 리스트의 길이
} SinglyLinkedList;
```

#### 단일 연결 리스트 초기화

리스트를 초기화하는 함수는 리스트의 길이를 0으로 설정하고, head 포인터를 NULL로 설정한다.

```c
SinglyLinkedList *init() {
    SinglyLinkedList *list = (SinglyLinkedList *)malloc(sizeof(SinglyLinkedList));
    list->head = NULL; // 첫 번째 노드에 대한 포인터 초기화
    list->length = 0; // 리스트의 길이 초기화
    return list;
}
```

길이를 확인하는 함수도 다음과 같이 정의할 수 있다:

```c
int length(SinglyLinkedList *list) {
    return list->length; // 리스트의 길이 반환
}
```

#### 단일 연결 리스트의 탐색 연산

탐색할 원소를 찾을 때까지 반복문을 돌리며, 현재 노드의 데이터와 탐색할 원소가 같으면 해당 노드를 반환한다.

시간 복잡도는 $O(n)$이다. (최악의 경우 모든 노드를 탐색해야 하므로)

```c
SinglyLinkedList *search(SinglyLinkedList *list, element item) {
    Node *current = list->head; // 첫 번째 노드부터 시작
    while (current != NULL) {
        if (current->data == item) {
            return current; // 찾는 원소를 찾음
        }
        current = current->link; // 다음 노드로 이동
    }
    return NULL; // 찾는 원소가 없음
}
```

#### 단일 연결 리스트의 삽입 연산

새 노드를 준비하고, 삽입할 위치에 따라 포인터를 조정한다.

1. 삽입할 노드 생성
2. 새 노드에 데이터 저장
3. 리스트가 비어있으면 head 포인터를 새 노드로 설정
4. 삽입할 위치가 첫 번째 노드이면 head 포인터를 새 노드로 설정
5. 삽입할 위치가 중간 노드이면 새 노드의 link를 pre의 link로 설정하고, pre의 link를 새 노드로 설정
6. 삽입할 위치가 마지막 노드이면 새 노드의 link를 NULL로 설정하고, pre의 link를 새 노드로 설정
7. 리스트의 길이 필드를 증가

삽입하고자 하는 위치에 따라 노드를 삽입하는 방법이 다르다.

각 위치에 따라 삽입하는 방법의 차이는 다음과 같다:

1. 첫 번째 노드에 삽입:
    - 새 노드의 링크값은 head가 가리키는 노드의 주소값
    - head 포인터를 새 노드로 변경

2. 중간 노드에 삽입:
    - 새 노드의 링크값은 삽입할 위치의 앞노드(pre)의 링크값
    - 삽입할 위치 앞 노드에 새 노드의 주소값을 저장

3. 마지막 노드에 삽입:
    - 새 노드의 링크값은 NULL
    - 마지막 노드의 링크값을 새 노드의 주소값으로 변경
    - 마지막 노드는 head부터 시작하여 link가 NULL인 노드를 찾으면 된다.

**노드에 대한 포인터가 주어진 경우** 시간 복잡도는 $O(1)$이다.

```c
void insert(SinglyLinkedList *list, SinglyLinkedListNode* pre, element x) {
    SinglyLinkedListNode *newNode = (SinglyLinkedListNode *)malloc(sizeof(SinglyLinkedListNode));
    newNode->data = x; // 새 노드에 데이터 저장

    // 리스트가 비어있는 경우 (HEAD가 NULL인 경우)
    if (list->head == NULL) {
        list = (SinglyLinkedList *)malloc(sizeof(SinglyLinkedList));
        list->head = newNode; // 첫 번째 노드로 설정
        newNode->link = NULL; // 다음 노드 없음
    // 삽입할 위치가 첫 번째 노드인 경우
    } else if (pre == NULL) {
        newNode->link = list->head; // 새 노드가 첫 번째 노드가 됨
        list->head = newNode; // 리스트의 head 포인터를 새 노드로 변경
    // 삽입할 위치가 중간 노드인 경우
    } else {
        newNode->link = pre->link; // 새 노드의 다음 노드를 pre의 다음 노드로 설정
        pre->link = newNode; // pre의 다음 노드를 새 노드로 설정
    }

    list->length++; // 리스트의 길이 증가
}
```

삽입 위치가 **맨 앞**과 **맨 뒤인** 경우는 다음과 같이 구현할 수 있다:

**맨 앞**의 경우에는 시간 복잡도가 $O(1)$이다.

**맨 뒤**의 경우에는 시간 복잡도가 $O(n)$이다. (리스트의 끝까지 가야 하므로)

```c
// 맨 앞 삽입
void insertFirst(SinglyLinkedList *list, element x) {
    SinglyLinkedListNode* newNode = (SinglyLinkedListNode *)malloc(sizeof(SinglyLinkedListNode));
    newNode->data = x; // 새 노드에 데이터 저장
    newNode->link = list->head; // 새 노드의 다음 노드를 현재 head로 설정
    list->head = newNode; // 리스트의 head 포인터를 새 노드로 변경
    list->length++; // 리스트의 길이 증가
}

// 맨 뒤 삽입
void insertLast(SinglyLinkedList *list, element x) {
    SinglyLinkedListNode* newNode = (SinglyLinkedListNode *)malloc(sizeof(SinglyLinkedListNode));
    newNode->data = x; // 새 노드에 데이터 저장
    newNode->link = NULL; // 새 노드의 다음 노드를 NULL로 설정

    if (list->head == NULL) {
        list->head = newNode; // 리스트가 비어있으면 head를 새 노드로 설정
    } else {
        SinglyLinkedListNode* current = list->head;
        while (current->link != NULL) {
            current = current->link; // 마지막 노드까지 이동
        }
        current->link = newNode; // 마지막 노드의 다음 노드를 새 노드로 설정
    }
    list->length++; // 리스트의 길이 증가
}
```

#### 단일 연결 리스트의 삭제 연산

**노드 포인터가 주어진 경우**, 앞 노드의 포인터를 조정, 삭제할 원소를 free한다.

리스트의 첫 번째 노드부터 시작하여, 현재 노드의 link가 삭제할 노드와 같지 않을 때까지 반복해서 삭제할 노드의 앞 노드를 찾는다.

1. 리스트의 첫 번째 노드부터 시작하여, 현재 노드의 link가 삭제할 노드와 같지 않을 때까지 반복
2. 현재 노드의 link가 삭제할 노드와 같으면, 현재 노드를 pre로 설정
3. pre의 link를 삭제할 노드의 link로 설정하여 삭제할 노드를 리스트에서 제거
4. 삭제할 노드를 free하여 메모리 해제

시간 복잡도는 $O(n)$이다. (최악의 경우 모든 노드를 탐색해야 하므로)

```c
int deleteNode(SinglyLinkedList *list, SinglyLinkedListNode *p) {
    // 리스트가 비어있거나 삭제할 노드가 NULL인 경우
    if (list == NULL || p == NULL) return -1;
    // 첫 번째 노드 삭제
    if (list->head == p) {
        list->head = p->link; // head 포인터를 다음 노드로 변경
    } else {
        SinglyLinkedListNode *pre = list->head;
        while (pre != NULL && pre->link != p) {
            pre = pre->link; // 삭제할 노드의 앞 노드 찾기
        }
        if (pre == NULL) return -1; // p가 리스트에 없는 경우
        pre->link = p->link; // 삭제할 노드를 리스트에서 제거
        // 마지막의 경우는 pre->link가 NULL
    }
    free(p); // 삭제할 노드 메모리 해제
    list->length--; // 리스트의 길이 감소
    return 0; // 성공적으로 삭제 
}
```

**데이터를 기준으로 삭제하는 경우**는 다음과 같이 구현할 수 있다:

시간복잡도는 search와 deleteNode를 합친 것과 같으므로 $O(n)$이다.

이해 편의상 search 함수는 사용하지 않고, deleteNode 함수에서 직접 삭제할 노드를 찾는다.

```c
int deleteByValue(SinglyLinkedList *list, element x) {
    // 리스트가 비어있거나 삭제할 원소가 NULL인 경우
    if (list == NULL || x == NULL) return -1;

    // 첫 번째 노드부터 시작
    SinglyLinkedListNode *cur = list->head;
    SinglyLinkedListNode *pre = NULL;

    // 삭제할 원소를 찾을 때까지 반복
    while (cur != NULL && cur->data != x) {
        pre = cur;
        cur = cur->link;
    }

    // 삭제할 원소를 찾지 못한 경우
    if (cur == NULL) return -1; // 찾는 원소가 없음

    // 삭제할 원소가 첫 번째 노드인 경우
    if (pre == NULL) {
        list->head = cur->link; // 첫 번째 노드 삭제
    // 삭제할 원소가 마지막 노드인 경우
    } else if (cur->link == NULL) {
        pre->link = NULL; // 마지막 노드 삭제
    // 삭제할 원소가 중간 노드인 경우
    } else {
        pre->link = cur->link; // 중간 노드 삭제
    }

    free(cur);
    list->length--;
    return 0;
}
```

#### 단일 연결 리스트의 표시 연산

리스트의 모든 원소를 출력하는 함수이다.

```c
void display(SinglyLinkedList *list) {
    SinglyLinkedListNode *current = list->head;
    while (current != NULL) {
        printf("%d -> ", current->data);
        current = current->link;
    }
    printf("NULL\n");
}
```

### 원형 연결 리스트

단순 연결 리스트에서 마지막 노드가 리스트의 첫 번째 노드를 가리키게하여 원형으로 연결한 구조이다.

따라서 링크를 따라 계속 순회하면 이전 노드에 접근 가능하다.

단, 다음 노드로만 이동 가능하며, 이전 노드로의 직접 접근은 불가능하다.

#### 원형 연결 리스트 구조체

원형 연결 리스트는 단일 연결 리스트와 유사하지만, 마지막 노드가 첫 번째 노드를 가리키도록 구현된다.

```c
// 노드 구조체: 각 노드는 데이터를 저장하고 다음 노드를 가리킨다.
typedef struct CircularLinkedListNode {
    element data;                           // 노드에 저장될 데이터
    struct CircularLinkedListNode *link;    // 다음 노드를 가리키는 포인터
} CircularLinkedListNode;

// 리스트 구조체: 리스트 전체를 관리하는 구조체
typedef struct {
    CircularLinkedListNode *head;   // 리스트의 첫 번째 노드를 가리키는 포인터
    CircularLinkedListNode *last;   // 리스트의 마지막 노드를 가리키는 포인터 (last->link == head)
    int length;                     // 리스트에 저장된 노드의 수
} CircularLinkedList;
```

#### 원형 연결 리스트의 삽입 연산

원형 연결 리스트의 삽입 연산은 단순 연결 리스트와 유사하다.

하지만 마지막 노드가 첫 번째 노드를 가리키고 있으므로, 삽입할 위치에 따라 포인터를 조정하는 방식이 다르다.

| 삽입 위치 | 방식 | 시간 복잡도 | 보조 포인터 필요 여부 |
|-----------|------|--------------|---------------------|
| head 앞 | head만 사용 | $O(n)$ | 마지막 노드 순회 필요 |
| head 앞 | last 사용 | $O(1)$ | 즉시 참조 가능 |
| 마지막 | head만 사용 | $O(n)$ | 마지막 노드 순회 필요 |
| 마지막 | last 사용 | $O(1)$ | 즉시 참조 가능 |

##### 첫 번째 노드로 삽입하는 경우

1. 삽입할 노드를 준비하고 데이터 필드에 값을 저장
2. 새 노드의 링크를 기존의 head가 가리키는 노드로 설정
3. 마지막 노드의 링크를 새 노드로 지정
4. head 포인터를 새 노드로 갱신
5. 리스트의 길이를 1 증가

이러한 방식은 리스트의 마지막 노드를 먼저 알아야 하므로, 일반적으로 다음과 같은 순회가 필요하다:

```c
// head부터 시작해 link를 따라가며 마지막 노드를 찾는다
CircularLinkedListNode *p = head;
while (p->link != head) {
    p = p->link;
}
// p는 마지막 노드 (p->link가 다시 head를 가리킴)
```

따라서 첫 번째 노드로 삽입하는 연산의 시간 복잡도는 $O(n)$이다.

왜냐하면 마지막 노드를 찾기 위해 전체 리스트를 순회해야 하기 때문이다.

###### $O(1)$로 최적화하려면?

마지막 노드를 따로 관리하는 last 포인터를 유지하면, 항상 마지막 노드를 즉시 참조할 수 있다.

이 경우의 구조적 특징:

- last->link는 항상 첫 번째 노드를 가리킨다. (head == last->link)
- 새로운 노드를 앞에 삽입할 때는:
  - newNode->link = last->link
  - last->link = newNode
  - head = newNode

```c
void insertFirst(CircularLinkedList *list, element x) {
    CircularLinkedListNode *newNode = (CircularLinkedListNode *)malloc(sizeof(CircularLinkedListNode));
    newNode->data = x; // 새 노드에 데이터 저장

    if (list->head == NULL) { // 리스트가 비어있으면
        newNode->link = newNode; // 자기 자신을 가리킴
        list->head = newNode; // 첫 번째 노드로 설정
        list->last = newNode; // 마지막 노드도 새 노드로 설정
    } else {
        newNode->link = list->head; // 새 노드의 link를 head로 설정
        list->last->link = newNode; // 마지막 노드의 link를 새 노드로 설정
        list->head = newNode; // head 포인터를 새 노드로 변경
    }
    list->length++; // 리스트의 길이 증가
}
```

##### 마지막 노드로 삽입하는 경우

마지막 노드 뒤에 새 노드를 삽입하면, last 포인터를 새 노드로 갱신해야 한다.

1. 삽입할 노드를 준비하고 데이터 필드에 값을 저장
2. 새 노드의 링크를 head로 설정
3. 기존 last 노드의 링크를 새 노드로 설정
4. last 포인터를 새 노드로 갱신
5. 리스트의 길이를 1 증가

last 포인터를 이용하여 직접 접근이 가능하기 때문에 시간복잡도는 $O(1)$이다.

```c
void insertLast(CircularLinkedList *list, element x) {
    CircularLinkedListNode *newNode = (CircularLinkedListNode *)malloc(sizeof(CircularLinkedListNode));
    newNode->data = x; // 새 노드에 데이터 저장

    if (list->head == NULL) { // 리스트가 비어있으면
        list->head = newNode; // 첫 번째 노드로 설정
        newNode->link = newNode; // 자기 자신을 가리킴
        list->last = newNode; // 마지막 노드도 새 노드로 설정
    } else {
        newNode->link = list->head; // 새 노드의 link를 head로 설정
        list->last->link = newNode; // 마지막 노드의 link를 새 노드로 설정
        list->last = newNode; // 마지막 노드를 새 노드로 변경
    }
    list->length++; // 리스트의 길이 증가
}
```

#### 원형 연결 리스트의 삭제 연산

삭제할 노드의 이전 노드를 찾아서 삭제할 노드의 링크를 조정하여 삭제한다.

1. 리스트가 비어있거나 삭제할 노드가 NULL인 경우를 검사
2. 삭제할 노드가 첫 번째 노드인 경우, head 포인터를 다음 노드로 설정
3. 삭제할 노드가 마지막 노드인 경우, 마지막 노드의 링크를 첫 번째 노드로 설정
4. 삭제할 노드의 이전 노드를 찾기 위해 리스트를 순회
5. 삭제할 노드의 이전 노드의 링크를 삭제할 노드의 링크로 설정
6. 삭제할 노드를 free하여 메모리 해제
7. 리스트의 길이 필드를 감소

```c
int deleteNode(CircularLinkedList *list, CircularLinkedListNode *p) {
    if (list == NULL || p == NULL || list->head == NULL) return -1;

    // 삭제할 노드가 유일한 노드일 경우
    if (list->head == p && list->head == list->last) {
        free(p);
        list->head = NULL;
        list->last = NULL;
    }
    // 삭제할 노드가 head인 경우 (but not the only one)
    else if (list->head == p) {
        list->head = p->link;
        list->last->link = list->head;
        free(p);
    }
    // 그 외 (중간 노드 또는 마지막 노드)
    else {
        CircularLinkedListNode *pre = list->head;
        while (pre->link != p && pre->link != list->head) {
            pre = pre->link;
        }

        if (pre->link != p) return -1; // 삭제할 노드를 못 찾은 경우

        pre->link = p->link;
        if (list->last == p) {
            list->last = pre; // 마지막 노드였다면 last 갱신
        }
        free(p);
    }
    list->length--; // 리스트의 길이 감소
    return 0; // 성공적으로 삭제
}
```

### 이중 연결 리스트

이중 연결 리스트는 각 노드가 이전 노드와 다음 노드에 대한 포인터를 모두 가진다.

단순 이중 연결 리스트와 원형 이중 연결 리스트의 두 가지 형태가 있다.

- 단순 이중 연결 리스트: 마지막 노드가 첫 번째 노드를 가리키지 않음
- 원형 이중 연결 리스트: 마지막 노드가 첫 번째 노드를 가리킴

#### 이중 연결 리스트 구조체

이중 연결 리스트는 단일 연결 리스트와 유사하지만, 각 노드가 이전 노드에 대한 포인터를 추가로 가진다.

다음과 같은 구조체로 구현된다:

```c
// 데이터 타입 정의
typedef int element;

// 노드 구조체: 각 노드는 데이터를 저장하고 이전 및 다음 노드를 가리킨다.
typedef struct DoublyLinkedListNode {
    element data; // 데이터
    struct DoublyLinkedListNode *prev; // 이전 노드에 대한 포인터
    struct DoublyLinkedListNode *next; // 다음 노드에 대한 포인터
} DoublyLinkedListNode;

// 리스트 구조체: 리스트 전체를 관리하는 구조체
typedef struct {
    DoublyLinkedListNode *head; // 첫 번째 노드에 대한 포인터
    DoublyLinkedListNode *tail; // 마지막 노드에 대한 포인터
    int length; // 리스트의 길이
} DoublyLinkedList;
```

#### 이중 연결 리스트의 삽입 연산

이중 연결 리스트는 각 노드가 next와 prev 포인터를 가지며, 양방향 순회가 가능하다.

1. 새 노드를 생성하고 data를 저장
2. 리스트가 비어있는 경우, head와 tail을 새 노드로 설정
3. 삽입 위치가 가장 앞인 경우, head 앞에 삽입
4. 삽입 위치가 중간 또는 마지막인 경우, 주어진 노드(pre) 뒤에 삽입
5. 모든 경우에 대해 prev, next 포인터를 적절히 조정
6. 리스트의 길이를 1 증가

삽입 위치에 따라 포인터 연결 방식이 다르다.

```c
void insert(DoublyLinkedList *list, DoublyLinkedListNode *pre, element x) {
    if (list == NULL) return; // 리스트가 NULL이면 아무것도 하지 않음

    DoublyLinkedListNode *newNode = (DoublyLinkedListNode *)malloc(sizeof(DoublyLinkedListNode));
    newNode->data = x;
    newNode->prev = NULL;
    newNode->next = NULL;

    // 리스트가 비어있으면 (head가 NULL일 때)
    if (list->head == NULL) {
        list->head = newNode;
        list->tail = newNode;
    }
    // 첫 번째 노드로 삽입하는 경우 (pre == NULL)
    else if (pre == NULL) {
        newNode->next = list->head;
        newNode->prev = NULL;
        list->head->prev = newNode;
        list->head = newNode;
    }
    // 중간 또는 마지막 노드 뒤에 삽입
    else {
        newNode->next = pre->next;
        newNode->prev = pre;
        if (pre->next != NULL) {
            pre->next->prev = newNode;
        } else {
            list->tail = newNode; // tail 갱신
        }
        pre->next = newNode;
    }

    list->length++;
}
```

#### 이중 연결 리스트의 삭제 연산

삭제할 노드의 이전 노드와 다음 노드를 연결하여 삭제할 노드를 리스트에서 제거한다.

```c
int deleteNode(DoublyLinkedList *list, DoublyLinkedListNode *p) {
    if (list == NULL || p == NULL) return -1; // 리스트가 비어있거나 삭제할 노드가 NULL인 경우

    if (p->prev != NULL) {
        p->prev->next = p->next; // 이전 노드의 다음을 삭제할 노드의 다음으로 설정
    } else {
        list->head = p->next; // 첫 번째 노드 삭제
    }

    if (p->next != NULL) {
        p->next->prev = p->prev; // 다음 노드의 이전을 삭제할 노드의 이전으로 설정
    } else {
        list->tail = p->prev; // 마지막 노드 삭제
    }

    free(p); // 메모리 해제
    list->length--; // 리스트의 길이 감소
    return 0;
}
```

### 연결 리스트의 활용

배열 리스트에서 구현한 다항식을 연결 리스트로도 구현할 수 있다.

#### 연결 리스트로 구현한 다항식 구조체

```c
typedef struct PolyNode {
    float coef; // 계수
    int exp; // 차수
    struct PolyNode *link; // 다음 항에 대한 포인터
} PolyNode;

typedef struct {
    PolyNode *head; // 첫 번째 항에 대한 포인터
    PolyNode *last; // 마지막 항에 대한 포인터
} Polynomial;
```

#### 연결 리스트로 구현한 다항식 삽입 연산

다항식 리스트의 마지막 요소 뒤에 항을 삽입한다.

연결 리스트의 마지막 노드로 삽입하는 알고리즘과 유사하다.

시간 복잡도는 $O(1)$이다.

```c
void appendTerm(Polynomial *poly, float coef, int exp) {
    PolyNode *newNode = (PolyNode *)malloc(sizeof(PolyNode));
    newNode->coef = coef;
    newNode->exp = exp;
    newNode->link = NULL;

    if (poly->head == NULL) {
        poly->head = newNode; // 첫 번째 항 삽입
    } else {
        poly->last->link = newNode; // 마지막 항 뒤에 삽입
    }
    poly->last = newNode;
}
```

#### 연결 리스트로 구현한 다항식 덧셈 연산

다항식의 덧셈 연산은 두 개의 다항식을 더하는 연산이다.

시간 복잡도는 $O(n)$이다. (각 다항식의 항을 한 번씩만 방문하면 되므로)

```c
Polynomial addPoly(Polynomial p1, Polynomial p2) {
    // 결과를 저장할 다항식 구조체
    Polynomial result;
    result.head = NULL;
    result.last = NULL;

    // 두 다항식의 첫 번째 항을 가리키는 포인터
    PolyNode *p1Node = p1.head;
    PolyNode *p2Node = p2.head;

    // 각 연결 리스트의 끝까지 반복
    while (p1Node != NULL && p2Node != NULL) {
        // 차수가 같은 경우
        if (p1Node->exp == p2Node->exp) {
            appendTerm(&result, p1Node->coef + p2Node->coef, p1Node->exp);
            p1Node = p1Node->link;
            p2Node = p2Node->link;
        // 차수가 다른 경우
        } else if (p1Node->exp > p2Node->exp) {
            appendTerm(&result, p1Node->coef, p1Node->exp);
            p1Node = p1Node->link;
        } else {
            appendTerm(&result, p2Node->coef, p2Node->exp);
            p2Node = p2Node->link;
        }
    }

    // 남아 있는 항들 붙이기
    while (p1Node != NULL) {
        appendTerm(&result, p1Node->coef, p1Node->exp);
        p1Node = p1Node->link;
    }

    while (p2Node != NULL) {
        appendTerm(&result, p2Node->coef, p2Node->exp);
        p2Node = p2Node->link;
    }

    return result;
}
```

## Stack

스택은 **LIFO**(Last In First Out) 구조로, 가장 나중에 들어온 원소가 가장 먼저 나간다.

> top이라는 한 쪽 끝에서 모든 연산이 일어나는 순서 리스트이다.

### 스택의 구현

배열과 연결 리스트로 구현할 수 있다.

#### 배열로 구현한 스택

1차원 배열 stack[MAX_SIZE]와 top 변수를 사용하여 구현한다.

가장 먼저 삽입된 요소는 stack[0]에 저장되고, 가장 나중에 삽입된 요소는 stack[top]에 저장된다.

배열 스택의 상태는 다음과 같이 나타낸다:

- 스택이 비어있을 때: `top = -1`
- 스택에 원소가 있을 때: `top = n - 1` (n은 스택의 크기)
- 스택이 포화상태일 때: `top = MAX_SIZE - 1`

##### 배열 스택 구조체

stack은 스택의 원소를 저장하는 배열이고, top은 스택의 가장 위에 있는 원소의 인덱스를 나타낸다.

```c
// 스택의 최대 크기
#define STACK_MAX_SIZE 100

// 스택의 원소 타입 정의
typedef int element;

// 스택 구조체 정의
typedef struct {
    element stack[STACK_MAX_SIZE]; // 스택을 저장할 배열
    int top; // 스택의 top 인덱스
} Stack;
```

##### 배열 스택 초기화

스택 구조체를 초기화하고 top을 -1로 설정한다.

```c
Stack* create() {
    Stack *s = (Stack *)malloc(sizeof(Stack));
    s->top = -1; // 스택의 top 인덱스 초기화
    return s;
}
```

상태를 확인하는 함수도 다음과 같이 정희할 수 있다:

```c
int isEmpty(Stack *s) {
    return s->top == -1; // 스택이 비어있음
}

int isFull(Stack *s) {
    return s->top == STACK_MAX_SIZE - 1; // 스택이 포화상태
}
```

##### 배열 스택의 삽입 연산

스택에 원소를 삽입하는 연산이다.

1. 스택이 포화상태인지 검사
2. 스택의 top을 1 증가
3. 삽입할 원소를 스택의 top에 저장

```c
void push(Stack *s, element item) {
    if (isFull(s)) {
        printf("스택이 포화상태입니다.\n");
        return;
    }
    // top을 1 증가시키고 원소 삽입
    // s->top += 1;
    // s->stack[s->top] = item;
    s->stack[++s->top] = item;
}
```

##### 배열 스택의 삭제 연산

스택에서 원소를 삭제하는 연산이다.

1. 스택이 비어있는지 검사
2. 삭제할 원소를 스택의 top에서 꺼냄
3. 스택의 top을 1 감소

```c
element pop(Stack *s) {
    if (isEmpty(s)) {
        printf("스택이 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    // 삭제할 원소를 스택의 top에서 꺼냄
    // element item = s->stack[s->top];
    // top을 1 감소시키고 원소 삭제
    // s->top -= 1;
    return s->stack[s->top--]; // 후위 연산자 사용
}
```

궁금할 수 있는게 원소를 삭제하지 않는다는 점인데 어차피 배열이라 삭제할 필요가 없다. 스택의 top을 감소시키는 것만으로도 삭제한 것과 같은 효과를 낸다. 왜냐하면 top이 가리키는 인덱스는 스택의 가장 위에 있는 원소를 가리키기 때문이다. 그냥 쓰레기값이 남아있을 뿐이다.

##### 배열 스택의 표시 연산

스택의 가장 나중에 들어온 원소를 출력만하는 함수이다.

pop과 다른 점은 스택의 top을 감소시키지 않는 것이다.

```c
element peek(Stack *s) {
    if (isEmpty(s)) {
        printf("스택이 비어있습니다.\n");
        return -1; // 스택이 비어있음
    }
    return s->stack[s->top]; // 스택의 top 원소 반환
}
```

#### 단순 연결 리스트로 구현한 스택

단순 연결 리스트로 구현한 스택은 각 노드가 다음 노드에 대한 포인터를 가지고 있는 구조이다.

가장 먼저 삽입된 요소는 마지막 노드가 되고, 가장 나중에 삽입된 요소는 첫 번째 노드가 된다.

즉, 단순 연결 리스트에서 첫 번째 노드로 삽입하는 연산과 동일하다.

> 스택의 top은 리스트의 첫 번째 노드에 대한 포인터이다.

##### 단순 연결 리스트 스택 구조체

노드 구조체와 스택 구조체를 정의한다.

```c
// 데이터 타입 정의
typedef int element;

// 노드 구조체: 각 노드는 데이터를 저장하고 다음 노드를 가리킨다.
typedef struct StackNode {
    element data; // 데이터
    struct StackNode *link; // 다음 노드에 대한 포인터
} StackNode;

// 스택 구조체: 스택 전체를 관리하는 구조체
typedef struct Stack {
    StackNode *top; // 스택의 top 노드에 대한 포인터 (head)
} Stack;
```

##### 단순 연결 리스트 스택 초기화

스택 구조체를 초기화하고 top을 NULL로 설정한다.

> `top`은 곧 `head`이다.

```c
Stack* create() {
    Stack *s = (Stack *)malloc(sizeof(Stack));
    s->top = NULL; // 스택의 top 노드에 대한 포인터 초기화
    return s;
}
```

상태를 확인하는 함수도 다음과 같이 정의할 수 있다:

```c
int isEmpty(Stack *s) {
    return s->top == NULL; // 스택이 비어있음
}

int isFull(Stack *s) {
    return 0; // 연결 리스트로 구현했으므로 포화상태 불가능
}
```

##### 단순 연결 리스트 스택의 삽입 연산

단순 연결 리스트에서 맨 처음 노드로 삽입하는 연산과 동일하다.

1. 새 노드를 생성하고, 삽입할 원소를 저장
2. 새 노드의 link를 스택의 top으로 설정
3. 스택의 top을 새 노드로 설정

```c
void push(Stack *s, element item) {
    StackNode *newNode = (StackNode *)malloc(sizeof(StackNode));
    newNode->data = item; // 새 노드에 데이터 저장
    newNode->link = s->top; // 새 노드의 link를 스택의 top으로 설정
    s->top = newNode; // 스택의 top을 새 노드로 설정
}
```

##### 단순 연결 리스트 스택의 삭제 연산

단순 연결 리스트에서 첫 번째 노드를 삭제하는 연산과 동일하다.

1. 스택이 비어있는지 검사
2. 삭제할 원소를 스택의 top에서 꺼냄
3. 스택의 top을 삭제할 원소의 link로 설정
4. 삭제할 원소를 free

```c
element pop(Stack *s) {
    if (isEmpty(s)) {
        printf("스택이 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    StackNode *temp = s->top; // 삭제할 원소를 스택의 top에서 꺼냄
    element item = temp->data; // 삭제할 원소의 데이터 저장
    s->top = temp->link; // 스택의 top을 삭제할 원소의 link로 설정
    free(temp); // 삭제할 원소를 free
    return item; // 삭제한 원소 반환
}
```

##### 단순 연결 리스트 스택의 표시 연산

pop과 다른 점은 스택의 top을 감소시키지 않는 것이다.

```c
element peek(Stack *s) {
    if (isEmpty(s)) {
        printf("스택이 비어있습니다.\n");
        return -1; // 스택이 비어있음
    }
    return s->top->data; // 스택의 top 원소 반환
}
```

### 스택의 활용

강의자료에서 다루고 있는 부분은 다음과 같다:

- 수식 괄호 검사
- 수식 표기법
- 미로 탐색

> 3가지 전부 시험에 출제할만한 부분이다.

#### 수식의 괄호 검사

스택을 이용하여 수식의 괄호가 올바르게 닫혔는지 검사하는 알고리즘이다.

1. 왼쪽 괄호의 개수와 오른쪽 괄호의 개수를 같음
2. 같은 괄호에서 왼쪽 괄호는 오른쪽 괄호보다 먼저 나와야 함
3. 괄호 사이에는 포함관계만 존재함

##### 수식의 괄호 검사 알고리즘

스택을 이용하여 수식의 괄호가 올바르게 닫혔는지 검사하는 알고리즘은 다음과 같다:

1. 왼쪽 괄호를 만나면 스택에 push
2. 오른쪽 괄호와 만나면 스택을 pop하여 오른쪽 괄호와 짝이 맞는지 검사
3. 마지막 괄호까지 조사한 후, 스택에 괄호가 남아 있으면 거짓

> 수식에 대한 괄호 검사가 끝났을 때 공백 스택이어야 한다.

```c
int checkParentheses(char *exp) {
    Stack *s = create(); // 스택 생성
    char ch;

    for (int i = 0; exp[i] != '\0'; i++) {
        ch = exp[i];
        if (ch == '(' || ch == '{' || ch == '[') {
            push(s, ch); // 왼쪽 괄호는 스택에 push
        } else if (ch == ')' || ch == '}' || ch == ']') {
            if (isEmpty(s)) {
                return 0; // 스택이 비어있으면 거짓
            }
            char top = pop(s); // 오른쪽 괄호는 스택에서 pop
            if ((ch == ')' && top != '(') ||
                (ch == '}' && top != '{') ||
                (ch == ']' && top != '[')) {
                return 0; // 짝이 맞지 않으면 거짓
            }
        }
    }

    int result = isEmpty(s); // 스택이 비어있으면 참, 아니면 거짓

    free(s);
    return result;
}
```

#### 수식 표기법

수식의 표기법은 다음의 것들이 있다:

- 중위 표기법 (Infix Notation)
가장 보편적인 표기법으로, 연산자가 피연산자 사이에 위치한다.
예를 들어, $A + B$와 같이 표현된다.

- 전위 표기법 (Prefix Notation)
연산자를 피연산자 앞에 위치시킨 표기법이다.
예를 들어, $+AB$와 같이 표현된다.

- 후위 표기법 (Postfix Notation)
괄호를 사용하지 않고, 연산자를 피연산자 뒤에 위치시킨 표기법이다.
예를 들어, $AB+$와 같이 표현된다.

##### 중위 표기법을 후위 표기법으로 변환하는 알고리즘

중위 표기법을 후위 표기법으로 바꾸는 방법을 이론적으로 설명하면 다음과 같다:

1. 연산자의 우선순위에 따라 괄호를 모두 삽입한다.
2. 각 연산자를 괄호 바깥으로 옮긴다.
3. 괄호를 제거한다.

하지만 이 방식은 실제 구현에 **비효율적**이므로, **스택을 이용한 변환 알고리즘**이 널리 사용된다.

##### 스택을 이용한 후위 표기법 변환 알고리즘

스택을 이용한 후위 표기법 변환 알고리즘은 다음과 같다:

- 괄호가 없는 경우

1. 피연산자는 즉시 출력
2. 연산자를 만났을 경우:
   - 스택이 비어있으면 push
   - 스택의 top에 있는 것보다 연산자의 우선순위가 더 높으면 push
   - 스택의 top에 있는 것보다 우선순위가 같거나 낮으면 pop하여 출력하고 다시 위의 작업을 반복
3. 수식이 끝났을 때 스택에 남은 연산자를 모두 pop하여 출력

- 예제
  - 수식: $A + B * C$
  - 후위 표기법: $ABC*+$

| Token | Stack | Top | Output |
|-------|-------|-----|--------|
| A     |       | -1  | A      |
| +     | +     | 0   | A      |
| B     | +     | 0   | AB     |
| *     | +*    | 1   | AB     |
| C     | +*    | 1   | ABC    |
| EOS   |       | -1  | ABC*+  |

- 괄호가 있는 경우

괄호가 없는 경우의 알고리즘에 괄호 처리만 추가하면 된다.

1. "("는 연산자로 두 가지 우선순위를 가짐
    - 수식에 있을 경우: 모든 다른 연산자보다 높은 우선순위를 가짐
    - 스택에 있을 경우: 모든 다른 연산자보다 낮은 우선순위를 가짐
2. ")"는 연산자로 간주하지 않고 이를 만나면 아래 작업을 수행
    - 스택에서 연산자를 하나씩 pop하여 이것이 "("이면 버리고 다음 토큰으로 진행
    - "("가 아니면 꺼낸 연산자를 출력하고 위의 작업을 반복

- 예제
  - 수식: $A * (B + C) * D$
  - 후위 표기법: $ABC+*D*$

| Token | Stack | Top | Output |
|-------|-------|-----|--------|
| A     |       | -1  | A      |
| *     | *     | 0   | A      |
| (     | *(    | 1   | A      |
| B     | *(    | 1   | AB     |
| +     | *(+   | 2   | AB     |
| C     | *(+   | 2   | ABC    |
| )     | *     | 0   | ABC+   |
| *     | *     | 0   | ABC+*  |
| D     | *     | 0   | ABC+*D |
| EOS   |       | -1  | ABC+*D*|

##### 스택을 이용한 후위 표기법 변환의 구현

위에서 본 내용을 코드로 구현해보자.

간략한 버전의 알고리즘은 다음과 같다:

1. 피연산자를 만나면 스택에 push
2. 연산자를 만나면 필요한 만큼의 피연산자를 스택에서 pop하여 연산을 수행
3. 연산 결과를 스택에 push
4. 수식이 끝나면 마지막으로 스택을 pop하여 결과를 출력

```c
void convertToPostfix(char *exp) {
    Stack *s = create(); // 스택 생성
    char ch;

    while (*exp != '\0') {
        ch = *exp; // 현재 문자
        switch (ch) {
            case '(': // 왼쪽 괄호
                push(s, ch); // 스택에 push
                break;
            case ')': // 오른쪽 괄호
                while (!isEmpty(s) && peek(s) != '(') {
                    printf("%c", pop(s)); // 스택에서 pop하여 출력
                }
                pop(s); // "("를 pop하여 버림
                break;
            case '+':
            case '-':
            case '*':
            case '/':
                while (!isEmpty(s) && precedence(peek(s)) >= precedence(ch)) {
                    printf("%c", pop(s)); // 스택에서 pop하여 출력
                }
                push(s, ch); // 현재 연산자를 스택에 push
                break;
            default: // 피연산자
                printf("%c", ch); // 피연산자는 즉시 출력
        }

        exp++; // 다음 문자로 이동
    }

    while (!isEmpty(s)) {
        printf("%c", pop(s)); // 수식이 끝나면 남은 연산자를 모두 pop하여 출력
    }

    free(s);
}
```

#### 미로 탐색

> 스택 문제로 출제 시 push/pop, dir, mark 흐름 파악이 핵심

- 미로는 2차원 배열로 주어지고, 각 칸은 다음과 같이 표시된다:
  - 0: 이동 가능 (빈 공간)
  - 1: 이동 불가능 (벽)

- 이동 방향은 8방향이며, move[8] 배열로 표현한다.

##### 방향 정의 (move[8])

```c
typedef struct {
    int vert;  // y축 방향
    int horiz; // x축 방향
} Move;

Move move[8] = {
    {-1, 0}, {-1, 1}, {0, 1}, {1, 1},
    {1, 0}, {1, -1}, {0, -1}, {-1, -1}
};
```

| 방향 | 방향 인덱스 | move[dirtection].vert | move[dirtection].horiz |
|------|-------------|-----------------------|------------------------|
| N | 0           | -1                    | 0                      |
| NE | 1           | -1                    | 1                      |
| E | 2           | 0                     | 1                      |
| SE | 3           | 1                     | 1                      |
| S | 4           | 1                     | 0                      |
| SW | 5           | 1                     | -1                     |
| W | 6           | 0                     | -1                     |
| NW | 7           | -1                    | -1                     |

##### 미로 탐색 알고리즘

스택을 이용하여 현재 경로를 기록하고, 더 이상 갈 곳이 없을 때 되돌아오기 위해 사용한다.

1. 현재 위치: [r, c], 방향: dir = 0
2. dir < 8 동안:
   - nextr = r + move\[dir].vert;
   - nextc = c + move\[dir].horiz;

3. 이동 가능 && 방문 안 했으면:
   - (r, c, dir+1)을 스택에 저장
   - r, c = nextr, nextc로 이동
   - mark\[r][c] = 1
   - dir = 0부터 다시 시작

4. 이동 불가능하면:
   - dir++

5. dir == 8이 되면:
   - 스택에서 pop → 백트래킹
   - 이전 위치와 저장된 dir로 복귀

6. 반복 종료 조건:
   - 현재 위치가 출구(\[endR][endC])일 때 종료
   - 스택이 비었으면 경로 없음

MARK 배열은 방문한 경로를 기록하는 배열이다.

이미 방문한 곳은 다시 가지 않기 위함이다. 즉, 백트레킹을 하더라도 방문한 곳은 다시 방문하지 않도록 한다.

```c
int mark[MAX][MAX]; // 방문 여부 체크
...
mark[r][c] = 1; // 이동 직후 방문 표시
```

스택에 저장되는 정보는 현재 위치와 다음 방향이다.

- 현재 위치 [r, c]
- 다음 탐색할 방향: dir + 1

> 나중에 되돌아왔을 때, 이미 시도한 방향은 건너뛰고 dir+1부터 다시 시도 가능

```c
typedef struct {
    int row; // 현재 위치의 행
    int col; // 현재 위치의 열
    int dir; // 현재 방향
} Position;

typedef struct {
    Position stack[MAX]; // 스택을 저장할 배열
    int top; // 스택의 top 인덱스
} Stack;
```

###### 핵심 규칙 요약

> “이동 가능 → push + 이동, 이동 불가 → dir++, 다 막히면 pop(백트래킹)”

| 상황 | 처리 방법 |
|-------|-----------|
| 이동 가능 | 스택에 현재 위치와 dir+1 저장 후 이동 |
| 이동 불가능 | dir++ |
| dir == 8 (막힘) | 스택에서 pop하여 이전 위치와 dir로 복귀 |
| 출구 도달 | 종료 |
| 스택 비어있음 | 경로 없음 |

## Queue

큐는 **FIFO**(First In First Out) 구조로, 가장 먼저 들어온 원소가 가장 먼저 나간다.

한쪽 끝(rear)에서 삽입하고, 다른 쪽 끝(front)에서 삭제한다.

### 큐의 구현

큐는 배열과 연결 리스트로 구현할 수 있다.

#### 배열 큐

1차원 배열 queue[QUEUE_MAX_SIZE]와 front, rear 변수를 사용하여 구현한다.

- front: 큐의 첫 번째 원소를 가리키는 인덱스
- rear: 큐의 마지막 원소를 가리키는 인덱스

상태 표현은 다음과 같다:

- 초기상태: front = reaar = -1
- 삽입상태: front = rear
- 포화상태: rear = QUEUE_MAX_SIZE - 1

##### 배열 큐 구조체

배열 큐는 큐의 원소를 저장하는 배열과 큐의 front와 rear를 나타내는 변수를 가진다.

```c
typedef int element;
typedef struct {
    element queue[QUEUE_MAX_SIZE]; // 큐를 저장할 배열
    int front; // 큐의 front 인덱스
    int rear; // 큐의 rear 인덱스
} Queue;
```

##### 배열 큐 초기화

큐 구조체를 초기화하고 front와 rear를 -1로 설정한다.

```c
Queue* create() {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->front = -1; // 큐의 front 인덱스 초기화
    q->rear = -1; // 큐의 rear 인덱스 초기화
    return q;
}
```

상태를 확인하는 함수는 다음과 같이 정의할 수 있다:

```c
int isEmpty(Queue *q) {
    return q->front == -1; // 큐가 비어있음
}

int isFull(Queue *q) {
    return q->rear == QUEUE_MAX_SIZE - 1; // 큐가 포화상태
}
```

##### 배열 큐의 삽입 연산

마지막 원소 뒤에 원소를 삽입하는 연산이다.

1. 마지막 원소의 인덱스를 저장한 rear값을 하나 증가시켜 삽입할 자리 준비
2. 수정한 rear값에 해당하는 배열 공간에 삽입할 원소를 저장

```c
void enqueue(Queue *q, element item) {
    if (isFull(q)) {
        printf("큐가 포화상태입니다.\n");
        return;
    }
    if (isEmpty(q)) {
        q->front = 0; // 큐가 비어있으면 front를 0으로 설정
    }
    q->rear += 1; // rear를 1 증가
    q->queue[q->rear] = item; // 큐의 rear에 원소 삽입
}
```

##### 배열 큐의 삭제 연산

가장 앞에 있는 원소를 삭제하는 연산이다.

1. 큐가 비어있는지 검사
2. front를 1 증가시켜 큐에 남아있는 첫 번째 원소의 위치로 이동하여 삭제
3. front 자리의 원소를 삭제하고 반환

```c
element dequeue(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    element item = q->queue[q->front]; // 삭제할 원소를 큐의 front에서 꺼냄
    if (q->front == q->rear) {
        q->front = -1; // 큐가 비어있으면 front를 -1로 설정
        q->rear = -1; // 큐가 비어있으면 rear도 -1로 설정
    } else {
        q->front += 1; // front를 1 증가
    }
    return item; // 삭제한 원소 반환
}
```

##### 배열 큐의 표시 연산

가장 앞에 있는 원소를 검색하여 반환하는데 현재 front의 한 자리 뒤에 있는 원소를 반환한다.

```c
element peek(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 큐가 비어있음
    }
    return q->queue[q->front]; // 큐의 front 원소 반환
}
```

##### 배열 큐의 문제점

삽입, 삭제가 여러번 일어나면 front와 rear가 배열의 끝에 도달하게 된다.

이 경우 큐가 비어있지 않더라도 삽입할 공간이 없게 된다.

이 문제를 해결하기 위해 원형 큐를 사용한다.

##### 원형 큐

논리적으로 배열의 끝과 처음이 연결되어 있는 형태로 구현한다.

원형 큐는 front와 rear가 배열의 끝에 도달했을 때, 다시 처음으로 돌아가게 된다.

원형 큐는 배열 큐와 동일한 구조체를 사용하지만, front와 rear의 위치를 나머지 연산을 통해 계산한다.

| 종류 | 삽입 위치 | 삭제 위치 |
|------|-----------|-----------|
| 배열 큐 | rear + 1 | front + 1 |
| 원형 큐 | (rear + 1) % QUEUE_MAX_SIZE | (front + 1) % QUEUE_MAX_SIZE |

공백상태와 포화상태를 구별하기 위해 하나의 공간은 **항상** 비워둔다.

상태 표현은 다음과 같다:

- 공백상태: front = rear = 0
- 포화상태: (rear + 1) % QUEUE_MAX_SIZE = front

###### 원형 큐 구조체

원형 큐는 배열 큐와 동일한 구조체를 사용하지만, front와 rear의 위치를 나머지 연산을 통해 계산한다.

```c
typedef int element;
typedef struct {
    element queue[QUEUE_MAX_SIZE]; // 큐를 저장할 배열
    int front; // 큐의 front 인덱스
    int rear; // 큐의 rear 인덱스
} Queue;
```

##### 원형 큐 초기화

큐 구조체를 초기화하고 front와 rear를 0으로 설정한다.

```c
Queue* create() {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->front = 0; // 큐의 front 인덱스 초기화
    q->rear = 0; // 큐의 rear 인덱스 초기화
    return q;
}
```

상태를 확인하는 함수는 다음과 같이 정의할 수 있다:

```c
int isEmpty(Queue *q) {
    return q->front == q->rear; // 큐가 비어있음
}

int isFull(Queue *q) {
    return (q->rear + 1) % QUEUE_MAX_SIZE == q->front; // 큐가 포화상태
}
```

##### 원형 큐의 삽입 연산

마지막 원소 뒤에 원소를 삽입하는 연산이다.

1. 큐가 포화상태인지 검사
2. rear의 값을 조정하여 삽입할 자리 준비
3. 수정한 rear값에 해당하는 배열 공간에 삽입할 원소를 저장

```c
void enqueue(Queue *q, element item) {
    if (isFull(q)) {
        printf("큐가 포화상태입니다.\n");
        return;
    }
    q->rear = (q->rear + 1) % QUEUE_MAX_SIZE; // rear를 1 증가
    q->queue[q->rear] = item; // 큐의 rear에 원소 삽입
}
```

##### 원형 큐의 삭제 연산

가장 앞에 있는 원소를 삭제하는 연산이다.

1. 큐가 비어있는지 검사
2. front의 값을 조정하여 삭제할 자리 준비
3. front 자리의 원소를 삭제하고 반환

```c
element dequeue(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    q->front = (q->front + 1) % QUEUE_MAX_SIZE; // front를 1 증가
    return q->queue[q->front]; // 삭제한 원소 반환
}
```

##### 원형 큐의 표시 연산

가장 앞에 있는 원소를 검색하여 반환하는데 현재 front의 한 자리 뒤에 있는 원소를 반환한다.

```c
element peek(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 큐가 비어있음
    }
    return q->queue[(q->front + 1) % QUEUE_MAX_SIZE]; // 큐의 front 원소 반환
}
```

#### 연결 리스트로 구현한 큐

단순 연결 리스트를 이용해서 큐를 구현해보자.

상태 표현은 다음과 같다:

- 공백상태: front = rear = NULL
- 포화상태: 없음 (연결 리스트로 구현했으므로 포화상태 불가능)

##### 연결 리스트 큐 구조체

큐의 front는 큐의 첫 번째 노드를 가리키고, rear는 큐의 마지막 노드를 가리킨다.

```c
typedef int element;
typedef struct QueueNode {
    element data; // 데이터
    struct QueueNode *link; // 다음 노드에 대한 포인터
} QueueNode;

typedef struct {
    QueueNode *front; // 큐의 front 노드에 대한 포인터
    QueueNode *rear; // 큐의 rear 노드에 대한 포인터
} Queue;
```

##### 연결 리스트 큐 초기화

공백 큐를 생성하는 함수는 front와 rear를 NULL로 설정한다.

```c
Queue* create() {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->front = NULL; // 큐의 front 노드에 대한 포인터 초기화
    q->rear = NULL; // 큐의 rear 노드에 대한 포인터 초기화
    return q;
}
```

상태를 확인하는 함수는 다음과 같이 정의할 수 있다:

```c
int isEmpty(Queue *q) {
    return q->front == NULL; // 큐가 비어있음
}

int isFull(Queue *q) {
    return 0; // 연결 리스트로 구현했으므로 포화상태 불가능
}
```

##### 연결 리스트 큐의 삽입 연산

1. 새 노드를 생성하고, 삽입할 원소를 저장
2. 큐가 비어있으면 front와 rear를 새 노드로 설정
3. 큐가 비어있지 않으면 rear의 link를 새 노드로 설정
4. rear를 새 노드로 설정

```c
void enqueue(Queue *q, element item) {
    QueueNode *newNode = (QueueNode *)malloc(sizeof(QueueNode));
    newNode->data = item; // 새 노드에 데이터 저장
    newNode->link = NULL; // 다음 노드 없음

    // 공백 큐일 경우 첫 노드이자 마지막 노드
    if (isEmpty(q)) {
        q->front = newNode; // 큐가 비어있으면 front도 새 노드로 설정
    } else {
        q->rear->link = newNode; // 기존 rear 노드의 link를 새 노드로 설정
    }
    q->rear = newNode; // 큐의 rear를 새 노드로 설정
}
```

##### 연결 리스트 큐의 삭제 연산

1. 큐가 비어있는지 검사
2. 삭제할 원소를 큐의 front에서 꺼냄
3. 큐의 front 포인터를 삭제할 원소의 link로 설정
4. 삭제할 원소를 free

```c
element dequeue(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    QueueNode *temp = q->front; // 삭제할 원소를 큐의 front에서 꺼냄
    element item = temp->data; // 삭제할 원소의 데이터 저장
    q->front = temp->link; // 큐의 front를 삭제할 원소의 link로 설정

    // 노드가 하나였을 경우
    if (q->front == NULL) {
        q->rear = NULL; // 큐가 비어있으면 rear도 NULL로 설정
    }
    free(temp); // 삭제할 원소를 free
    return item; // 삭제한 원소 반환
}
```

##### 연결 리스트 큐의 표시 연산

연결 큐의 첫 번째 노드, 즉 front가 가리키고 있는 노드의 데이터를 출력하는 함수이다.

```c
element peek(Queue *q) {
    if (isEmpty(q)) {
        printf("큐가 비어있습니다.\n");
        return -1; // 큐가 비어있음
    }
    return q->front->data; // 큐의 front 원소 반환
}
```

## Deque

Deque는 Double-ended Queue의 약자로, 양쪽 끝에서 삽입과 삭제가 가능한 큐이다.

Deque는 스택과 큐의 장점을 모두 가지고 있다.

### Deque의 구현

Doubly Linked List로 구현해보자.

#### Deque 구조체

```c
typedef int element;
typedef struct DequeNode {
    element data; // 데이터
    struct DequeNode *prev; // 이전 노드에 대한 포인터
    struct DequeNode *next; // 다음 노드에 대한 포인터
} DequeNode;

typedef struct {
    DequeNode *front; // Deque의 front 노드에 대한 포인터
    DequeNode *rear; // Deque의 rear 노드에 대한 포인터
} Deque;
```

#### Deque 초기화

Deque 구조체를 동적 할당하고, front와 rear 포인터를 NULL로 설정한다.

```c
Deque* create() {
    Deque *d = (Deque *)malloc(sizeof(Deque));
    d->front = NULL; // Deque의 front 노드에 대한 포인터 초기화
    d->rear = NULL; // Deque의 rear 노드에 대한 포인터 초기화
    return d;
}
```

상태를 확인하는 함수는 다음과 같이 정의할 수 있다:

```c
int isEmpty(Deque *d) {
    return d->front == NULL; // Deque가 비어있음
}

int isFull(Deque *d) {
    return 0; // 연결 리스트로 구현했으므로 포화상태 불가능
}
```

#### Deque의 삽입 연산

Deque에 원소를 삽입하는 연산이다.

1. 새 노드를 생성하고, 삽입할 원소를 저장
2. 삽입할 위치에 따라 포인터를 조정한다.
3. front와 rear 포인터를 조정한다.
4. Deque의 길이를 증가시킨다.

```c
void insertFront(Deque *d, element item) {
    DequeNode *newNode = (DequeNode *)malloc(sizeof(DequeNode));
    newNode->data = item; // 새 노드에 데이터 저장
    newNode->prev = NULL; // 이전 노드 없음
    newNode->next = d->front; // 새 노드의 다음 노드를 Deque의 front로 설정

    if (isEmpty(d)) {
        d->rear = newNode; // Deque가 비어있으면 rear도 새 노드로 설정
    } else {
        d->front->prev = newNode; // 기존 front 노드의 이전 노드를 새 노드로 설정
    }
    d->front = newNode; // Deque의 front를 새 노드로 설정
}
```

```c
void insertRear(Deque *d, element item) {
    DequeNode *newNode = (DequeNode *)malloc(sizeof(DequeNode));
    newNode->data = item; // 새 노드에 데이터 저장
    newNode->next = NULL; // 다음 노드 없음
    newNode->prev = d->rear; // 새 노드의 이전 노드를 Deque의 rear로 설정

    if (isEmpty(d)) {
        d->front = newNode; // Deque가 비어있으면 front도 새 노드로 설정
    } else {
        d->rear->next = newNode; // 기존 rear 노드의 다음 노드를 새 노드로 설정
    }
    d->rear = newNode; // Deque의 rear를 새 노드로 설정
}
```

#### Deque의 삭제 연산

Deque에서 원소를 삭제하는 연산이다.

1. Deque가 비어있는지 검사
2. 삭제할 원소를 Deque의 front에서 꺼냄
3. Deque의 front 포인터를 삭제할 원소의 next로 설정
4. 삭제할 원소를 free
5. Deque의 길이를 감소시킨다.

```c
element deleteFront(Deque *d) {
    if (isEmpty(d)) {
        printf("Deque가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    DequeNode *temp = d->front; // 삭제할 원소를 Deque의 front에서 꺼냄
    element item = temp->data; // 삭제할 원소의 데이터 저장
    d->front = temp->next; // Deque의 front를 삭제할 원소의 next로 설정

    if (d->front != NULL) {
        d->front->prev = NULL; // 새로운 front 노드의 이전 노드를 NULL로 설정
    } else {
        d->rear = NULL; // Deque가 비어있으면 rear도 NULL로 설정
    }

    free(temp); // 삭제할 원소를 free
    return item; // 삭제한 원소 반환
}
```

```c
element deleteRear(Deque *d) {
    if (isEmpty(d)) {
        printf("Deque가 비어있습니다.\n");
        return -1; // 삭제할 원소가 없음
    }
    DequeNode *temp = d->rear; // 삭제할 원소를 Deque의 rear에서 꺼냄
    element item = temp->data; // 삭제할 원소의 데이터 저장
    d->rear = temp->prev; // Deque의 rear를 삭제할 원소의 prev로 설정   

    if (d->rear != NULL) {
        d->rear->next = NULL; // 새로운 rear 노드의 다음 노드를 NULL로 설정
    } else {
        d->front = NULL; // Deque가 비어있으면 front도 NULL로 설정
    }

    free(temp); // 삭제할 원소를 free
    return item; // 삭제한 원소 반환
}
```
