# ENGN1580 Spectrum Challenge 
Team Members 
* Haley Mander 
* Laura Dayton 
* Greg Fine
* Jarod Boone 

## Challenge Overview 
We have to implement a transmitter (**send\_\*.m**) and a receiver (**reci\_\*.m**) for three seperate stages. The implementation is done in Matlab and will be graded in a manner similair to the events of **run_example.m** 

We will be graded differently depending on each challenge

For the first challenge only one transmitter receiver pair of our design is run in the presence of noise. We are graded on how many bits we can properly send and receive. 

For the second challenge a transmitter receiver pair of our design is run in the prescence of noise and a transmitter reciever pair designed by another group. Here we are graded on how many bits we correctly transmit and recieve as well as how **few** bits the other group transmits and receives. We are working against the other team. 

For the third challenge a transmitter receiver pair of our design is run in the prescence of noise and a transmitter reciever pair designed by another group.  Here we are graded on how many bits we correctly transmit and recieve as well as how **many** bits the other group transmits and receives. We are working together with the other team. 

## Challenge Structure 
Each challenge stage is conducted via the **testing_ground_3.m** function. This takes in the gamemode (challenge stage), function handles for the receivers from up to 2 teams and a boolean indicator that decides whether or not the messages are the same for for the two teams. 

The reciever and transmitter functions have essentially the same function signatures save for the sender which takes in and has access to the `msg` variable. 

```matlab
    function [signal_point,new_data,new_msg] = send(r_trans,r_reci,t,n,e,data,msg)
    function [signal_point,new_data,new_bits] = reci(r_reci,r_trans,t,n,e,data)
```

An overview of the common variables and their usage within the transciever functions:

| Parameter      | Description                                                                     |
|----------------|---------------------------------------------------------------------------------|
| `t`            | The time domain used to create different axes for signal space                  |
| `e`            | The current energy left for use by this device                                  |
| `n`            | The floor of this value divided by 2 is the iteration we are on                 |
| `r_trans`      | A vector of every bit that has been transmitted so far (indexed by n)           |
| `r_reci`       | A vector of every bit that has been received (guessed) so far                   |
| `signal_point` | A vector representing a point either encoded or to be decoded from signal space |
| `data`         | A scratchpad memory vector for the transceiver that can be treated however      |

Every `2n` steps we go through one cycle. Essentially the sender has access to the message and iterates over the bits sending them in some chosen increment size on every invocation via the signal point. The sender changes its data and message input and outputs a signal point. 

After this the reciever uses the transmission history to identify what was just sent by the sender and tries to decode new bits to add to the receiver history. The reciever does not need to generate a signal point. 