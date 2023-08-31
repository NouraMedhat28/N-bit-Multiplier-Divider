# N-bit-Multiplier-Divider
### The repository has the implementation of a N-bit multiplier/divider. We have built 4 modules, sequential multiplier, sequential divider, combination multiplier, and combinational divider.

## - Sequential Multiplier
### - Booth's Algorithm
#### In order to build a sequential multiplier, Booth's algorithm was chosen for this task. Booth's algorithm has its own decoding table, which is as follows:
![IMG_20230831_164425](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/247da74f-f88a-4104-841f-35dcf9fee2e6)
To understand the algorithm in detail, here is the flowchart illustrating it.
![IMG_20230831_164736](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/f440f359-a24b-4e89-a320-68806d7869bf)
Also, here is an example in which I was multipling 3 by 6, using the algorithm.
![IMG_20230831_164959](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/10c3491a-a5b0-41db-93d8-ddc59beb4165)
### - Booth's Algorithm Implementation
#### In order to implement any sequential circuit, we have 2 approaches, we can implement it using FSM and it is also valid to implement it without it. I have implemented it in both techniques.
- ## Using FSM:
I have implemented 2 designs, the first one is illustrated as follows
![IMG_20230831_165336](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/22caf6f8-8d3a-409f-b062-41580fff71c0)
As  shown,  we  had  4 states.  For  4bit inputs,  if  we  wanted  to  calculate  the  needed number of clock  cycles  to  complete  the calculations,  it  would  be as follows: 1  cycle  for  loading,  4  cycles  for  performing  the  iterations  of  the  algorithm  itself,  1 cycle  to  state  that  the  calculations  are  done,  which  is  the  “Done”  state  and  finally 1  cycle  to  reset  the  registers,  which  is  the  “IDLE”  state. So,  for  Nbit  inputs,  we will  need  N+2  clock  cycles  to  get  the  final  reset  and  one  cycle  to  reset  the  register. To  make  the  design  more  optimized  in  terms  of  the  number  of clock  cycles,  we needed  to  reduce the number of states.

The secode design was for optimization in the number of clock cycles, and it is illustrated as follows: 
![IMG_20230831_165632](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/3f1573e7-d6ae-4e29-882e-b9adf30dac44)

- ### Without FSM
We  can  design  a  sequential  circuit  without  FSM.  Here  we  had  another methodology  in  the  design.  And  for  Nbit  inputs,  we  need  N  clock  cycles.

## - Combinational Divider
### - Restoring Algorithm
#### In order to build a sequential multiplier, Restoring algorithm was chosen for this task. Here is the flowchart of the algorithm
![IMG_20230831_170837](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/ed36a6c7-1717-4240-bdab-d52364703036)
#### Here is an example, in which I was dividing -7/-4 
![IMG_20230831_170903](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/77a86f6b-e0b1-40ad-ab38-87dc0727723b)

## Integration
#### We have implemented  mainly  4 architectures
- Combinational  Multiplier
- Sequential Multiplier
-  Combinational  Divider
-  Sequential  Divider integrated
#### Then  we combined  the combinational  architectures  in  one architecture.  We had  done  the same with  the sequential  ones. Then  we them in  a  single architecture.
![IMG_20230831_172546](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/3b72ecbb-bdcb-4d52-8186-3509d26c5c80)


## Testing 
### Test plan for multiplier 
#### If we set our generic to 4, this means that to test the whole design, we need to enter 2^4 = 16 inputs. As we have 2 inputs, this means that we need to apply 16*16 = 256 test cases, which is definitely difficult and time consuming. In order to avoid this, we needed to study the corner cases, which were, from our point of view, as follows: 
#### ● Q: +ve, M: -ve 
#### ● Q: -ve, M:+ve 
#### ● Q: -ve, M: -ve 
#### ● Q: +ve, M: +ve
#### ● Q and M are equal to the maximum positive number
#### ● Q and M are equal to the maximum negative number
#### ● Q: Zero, M: Any number
#### ● Q: 1, M: Any number 
#### The testbenches was done using 2 different approaches: the first one using assertions and the second one using text files.
- Using Assertions
![IMG_20230831_171505](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/b330b893-7e0b-485c-bf56-180f59c11e1b)
- Using Files
![IMG_20230831_171554](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/cc5d9114-e870-4473-8102-e29a28f16ee2)

### Test plan for divideder
#### We  have  done  the  same  as  we  have  done  in  the case  in  which  we divide by  zero (Here, there is a new signal which is the error signal, it is asserted in case of the division by zero)
- Using Assertions
![IMG_20230831_171811](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/bf552696-8788-41fd-a859-3dbf9b54c977)
- Using Files
![IMG_20230831_171921](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/29cc2819-ba91-44f7-bfee-8eb7fc6981d6)

### System Testing 
- Test cases ![IMG_20230831_172039](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/657d4659-eebb-41c2-adf3-22673140128c)
- Test Results
![IMG_20230831_172112](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/114c44d8-1ee2-4f77-9ee0-fffbf5f20f5a)
#### We have also developed a testbench, to compare the sequential results to the combinational ones.
#### Test cases
![IMG_20230831_172853](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/1dd41b41-f4ae-473a-88a1-2f2f9697d21e)
#### Test Results
![IMG_20230831_173006](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/0420cd79-ab25-4afc-a076-115915dcaa03)

#### Other contributors: 
- Abdulrahman Mohamed NourEldeen  Hamza
- Kareem  Elsaeed  Abdel Hafez
- Khaled  Khalifa  Abd  elHay  Said





















