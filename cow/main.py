import numpy as np
import re


def read_cow_text(name):
    print(f"File {name} Execution Result:")
    file = open(name, 'r')
    f = file.read()

    string = re.sub(r'\n', r' ', f).split(' ')
    #print(string)
    arr = []
    d = {}
    ind = 0

    for i in string:
        if i == 'MOO': #конец цикла
            arr.append(ind)
            #print('конец цикла')
        if i == 'moo': #начало цикла
            d[ind] = arr[len(arr) - 1]
            d[arr.pop()] = ind
            #print('начало цикла')
        ind += 1

    res = np.zeros(10000)
    ind = 0
    i = 0

    while (i != len(string)):
        # MoO - значение текущей ячейки увеличить на 1
        if string[i] == 'MoO':
            res[ind] += 1
            #print('значение текущей ячейки увеличить на 1')

        # MOo - значение текущей ячейки уменьшить на 1
        if string[i] == 'MOo':
            res[ind] -= 1
            #print('значение текущей ячейки уменьшить на 1')

        # moO - следующая ячейка
        if string[i] == 'moO':
            ind += 1
            #print('следующая ячейка')

        # mOo - предыдущая ячейка
        if string[i] == 'mOo':
            ind -= 1
            #print('предыдущая ячейка')

        # moo - начало цикла
        if string[i] == 'moo':
            i = d[i] - 1
            #print('начало цикла')

        # MOO - конец цикла
        if string[i] == 'MOO':
            if res[ind] == 0:
                i = d[i]
                #print('конец цикла')

        # OOM - вывод значения текущей ячейки  
        if string[i] == 'OOM':
            #print('вывод значения текущей ячейки')
            print(int(res[ind]), end='')

        # oom - ввод значения в текущую ячейку
        if string[i] == 'oom':
            res[ind] = input()
            #print('ввод значения текущей ячейки')

        # mOO - выполнить инструкцию с номером из текущей ячейки              
        if string[i] == 'mOO':
            res[ind] = i
            #print('выполнить инструкцию с номером из текущей ячейки')

        # Moo - если значение в ячейке равно 0, то ввести с клавиатуры, если значение не 0, то вывести на экран
        if string[i] == 'Moo':
            #print('если значение в ячейке равно 0, то ввести с клавиатуры, если значение не 0, то вывести на экран')
            if string[ind] != 0:
                print(chr(int(res[ind])), end='')
            else:
                input("Enter your value")

        # OOO - обнулить значение в ячейке        
        if string[i] == 'OOO':
            #print('обнулить значение в ячейке')
            string[ind] = 0
        else:
            i += 1
            continue
        i += 1
    print("\n")



if __name__ == "__main__":
    read_cow_text("hello.cow")
