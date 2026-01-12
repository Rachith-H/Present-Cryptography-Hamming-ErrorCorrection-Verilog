# RTL Implementation of PRESENT Cipher with Hamming Error Correction
---
# Table of Contents

---
# Introduction
This project focuses on the hardware implementation of a secure communication system by integrating the PRESENT lightweight block cipher with Hamming error correction.
Encryption and decryption ensure data confidentiality, while error correction improves robustness against transmission errors.
The work emphasizes modular RTL design and testbench based verification.

---
# Methodology
- Implemented the PRESENT lightweight block cipher in Verilog for both encryption and decryption.
- Verified encryption and decryption using independent testbenches and official test vectors from the original PRESENT paper.
- Designed a 16-bit Hamming encoder and decoder and validated their functionality by injecting single-bit errors through testbenches.
- Developed a transmitter module where the 64-bit encrypted output is divided into four 16-bit chunks and encoded using parallel Hamming encoders, producing an 84-bit transmittable data stream.
- Implemented a receiver module that decodes the received data using Hamming decoders, correcting single-bit errors in each chunk.
- Recombined the corrected data and applied PRESENT decryption to recover the original plaintext.
- Verified the complete transmitter–receiver chain in a single testbench by injecting one error per chunk and confirming correct data recovery.


# IN PROGRESS....
