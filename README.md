# N-bit-Multiplier-Divider
### The repository has the implementation of a N-bit multiplier/divider. We have built 4 modules, sequential multiplier, sequential divider, combination multiplier, and combinational divider.

## - Sequential Multiplier
### - Booth's Algorithm
#### In order to build a sequential multiplier, Booth's algorithm was chosen for this task. Booth's algorithm has its own decoding table, which is as follows:
![IMG_20230831_164425](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/9ed15314-54f2-459d-b6fa-73aff0b13ca1)
To understand the algorithm in detail, here is the flowchart illustrating it.
![IMG_20230831_164736](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/2a928326-ae8a-4c07-a594-da624ac0b0b6)
#### Also, here is an example in which I was multipling 3 by 6, using the algorithm.
![IMG_20230831_164959](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/0d09b5d2-e6ad-44e8-8e86-f0eba5b0eebc)
### - Booth's Algorithm Implementation
#### In order to implement any sequential circuit, we have 2 approaches, we can implement it using FSM and it is also valid to implement it without it. I have implemented it in both techniques.
- ## Using FSM:
I have implemented 2 designs, the first one is illustrated as follows
![IMG_20230831_165336](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/f7121d62-9e0a-4db9-8345-2390a091e274)
#### As  shown,  we  had  4 states.  For  4bit inputs,  if  we  wanted  to  calculate  the  needed number of clock  cycles  to  complete  the calculations,  it  would  be as follows: 1  cycle  for  loading,  4  cycles  for  performing  the  iterations  of  the  algorithm  itself,  1 cycle  to  state  that  the  calculations  are  done,  which  is  the  “Done”  state  and  finally 1  cycle  to  reset  the  registers,  which  is  the  “IDLE”  state. So,  for  Nbit  inputs,  we will  need  N+2  clock  cycles  to  get  the  final  reset  and  one  cycle  to  reset  the  register. To  make  the  design  more  optimized  in  terms  of  the  number  of clock  cycles,  we needed  to  reduce the number of states.

The secode design was for optimization in the number of clock cycles, and it is illustrated as follows: 
![IMG_20230831_165632](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/d3912ef7-48e7-4841-bd8e-1365d41022a9)
- ### Without FSM
We  can  design  a  sequential  circuit  without  FSM.  Here  we  had  another methodology  in  the  design.  And  for  Nbit  inputs,  we  need  N  clock  cycles.

## - Combinational Divider
### - Restoring Algorithm
#### In order to build a sequential multiplier, Restoring algorithm was chosen for this task. Here is the flowchart of the algorithm
![IMG_20230831_170837](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/caf93241-0544-4407-a95a-9452e4b54b41)
#### Here is an example, in which I was dividing -7/-4 
![IMG_20230831_170903](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/e232b188-e82e-4d5d-8724-8fe6156db797)

## Integration
#### We have implemented  mainly  4 architectures
- Combinational  Multiplier
- Sequential Multiplier
-  Combinational  Divider
-  Sequential  Divider integrated
#### Then  we combined  the combinational  architectures  in  one architecture.  We had  done  the same with  the sequential  ones. Then  we them in  a  single architecture.
![IMG_20230831_172546](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/ef89bb92-90a4-4c23-a0a4-069a0a83e624)

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
##### Using Assertions
![IMG_20230831_171505](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/ff396e54-e115-4534-b8bf-f617cb400664)

##### Using Files
![IMG_20230831_171554](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/2f310c51-0bb4-43b4-bdee-bb0f9abcbcb6)

### Test plan for divideder
#### We  have  done  the  same  as  we  have  done  in  the case  in  which  we divide by  zero (Here, there is a new signal which is the error signal, it is asserted in case of the division by zero)
##### Using Assertions
![IMG_20230831_171811](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/25414242-c861-410a-89fd-fc35b6aab753)

##### Using Files
![IMG_20230831_171921](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/0ddf7e79-f180-483e-abda-5a36a21044d8)

### System Testing 
##### Test cases 
![IMG_20230831_172039](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/bb9210a2-fd78-4f0b-b927-92505e4b2412)

##### Test Results
![IMG_20230831_172112](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/bf239330-d93b-4c0c-8a31-2762fc33b7db)

#### We have also developed a testbench, to compare the sequential results to the combinational ones.
#### Test cases
![IMG_20230831_172853](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/d3c62b3d-f64f-4053-8ac9-f2efb8d23305)

#### Test Results
![IMG_20230831_173006](https://github.com/NouraMedhat28/N-bit-Multiplier-Divider/assets/96621514/7e8e6c9c-0e8e-4917-acad-069e7ea9b70e)


#### Other contributors: 
- Abdulrahman Mohamed NourEldeen  Hamza
- Kareem  Elsaeed  Abdel Hafez
- Khaled  Khalifa  Abd  elHay  Said





















