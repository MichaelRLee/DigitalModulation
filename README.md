# DigitalModulation
A small demonstration of the theory behind digital modulation techniques

Featured in this repo are some examples of Binary Amplitude Shift Keying (BASK), Binary Phase Shift Keying (BPSK), and Binary Frequency Shift Keying (BFSK).

Demo.m Generates a digital signal and shows how the signal can be transmitted using each of the three digital modulation techniques.  It also generates random noise (gausian distribution) and shows how it affects each modulation technique.

Final.m Shows, through abstract represenation of the signals, how well each of the digital modulation techniques deals with increasing amounts of noise, and compares it to the theoretical value.



A note on BFSK
BFSK has been represented as a series of 0 or 1, coresponding to two frequencies, f0 and f1.  When determining if a recieved signal represents a 0 or 1, the signal is run through 2 low pass filters, coresponding to the two frequencies.  The filtering either returns the amplitude of the wave, or 0, although these values are not exact because of noise added to the signal through transmission and the low pass filters.  Whichever filter returns the highest value, the value the coresponding frequenquency represents is considered the to be the value of the bit.  This can be represented as ::

    if signal == 0
        if Amplitude+noise1 > noise2
            return 0;
        else<br />
            return 1;
        end
    else
        if Amplitude+noise2 > noise1
            return 1;
        else
            return 0;
        end
    end

It can be observed that we have an incorrect bit only when the amplitude plus some noise is less than some other random noise.  Thus, the lines ::

    if FSKy0(j) > (FSKy1(j))
        FSK_BER(i) = FSK_BER(i)+1;
    end

in Final.m
