# RTX 3070 Ti Laptop 8 GB - at home

Install time: 8 min 18 sec

gemma3:4b 
- 16384: 4566 MB - 74 tokens/sec
- 32768: 4900 MB - 71 tokens/sec
- 65536: 5610 MB
- 98304: 6346 MB - 58 tokens/sec
- 131072: 7082 MB- 28 tokens/sec

qwen3:4b - 89 tokens/sec
- 16384: 5508 MB
- 24576: 6764 MB
- 32768: 8% CPU / 92% GPU - 56 tokens/sec

qwen3-vl:4b
- 16384: 6439 MB - 94 tokens/sec
- 24576: 7611 MB - 87 tokens/sec => 100% GPU
- 32768: 17% CPU / 83% GPU - 59 tokens/sec

ministral-3:3b - 112 tokens/sec
- 16384: 6312 MB
- 24576: 7144 MB
- 32768: 18% CPU / 82% GPU - 64 tokens/sec

embeddinggemma:300m    85462619ee72    1.1 GB    100% GPU     2048       Forever 

qwen3-embedding:0.6b    ac6da0dfba84    3.5 GB    100% GPU     16384      Forever 

+ Use CLINE with small models

# RTX 5070 Ti 16 GB - Vast.ai

Install time : 10 min 30 sec

gemma3:12b 
- 32768: 10856 MB - 83 tokens/sec
- 65536: 13905 MB - 77 tokens/sec
- 98304: 15090 MB - 79 tokens/sec => 100% GPU but too big to accomodate embeddinggemma
- 
qwen3:14b
- 32768: 14084 MB - 75 tokens/sec
- 65536: 15532 MB - 75 tokens/sec => 100% GPU

there is no qwen3-vl:14b (8b only)

ministral-3:8b
- 32768: 10954 MB - 123 tokens/sec
- 65536: 15306 MB - 122 tokens/sec => 100% GPU

ministral-3:14b
- 32768: 14568 MB - 85 tokens/sec
- 65536: 24% CPU / 76% GPU - 22 tokens/sec

gpt-oss:20b
- 32768: 13424 MB - 154 tokens/sec
- 65536: 14258 MB - 149 tokens/sec
- 98304: 15122 MB - 148 tokens/sec => 100% GPU

# RTX 4090 24 GB - at home



# RTX 5090 32 GB - at home

gemma3:27b 
- 32768: 21323 MB - 70 tokens/sec
- 65536: 23947 MB - 70 tokens/sec
- 98304: 26567 MB - 70 tokens/sec
- 131072: 29205 MB - 70 tokens/sec

qwen3:30b
- 32768: 22077 MB - 192 tokens/sec
- 65536: 25209 MB - 192 tokens/sec
- 98304: 28377 MB - 195 tokens/sec
- 131072: 31545 MB - 195 tokens/sec

qwen3-coder:30b
- 32768: 21598 MB - 192 tokens/sec
- 65536: 24734 MB - 194 tokens/sec
- 98304: 27902 MB - 196 tokens/sec
- 131072: 31070 MB - 198 tokens/sec

qwen3-vl:30b
- 24576: 22240 MB - 192 tokens/sec
- 32768: 23102 MB - 193 tokens/sec
- 65536: 26452 MB - 193 tokens/sec
- 98304: 29904 MB - 193 tokens/sec
- 106496: 30746 MB - 193 tokens/sec
- 131072: 5%/95% CPU/GPU - 45 tokens/sec

qwen3-vl:32b
- 32768: 29680 MB - 62 tokens/sec
- 40960: 31822 MB - 63 tokens/sec
- 65536: 18%/82% CPU/GPU - 10 tokens/sec

nemotron-3-nano:30b
- 32768: 24266 MB - 260 tokens/sec
- 65536: 27 GB - 260 tokens/sec
- 131072: 29 GB - 259 tokens/sec
- 
- 262,144: 7%/93% CPU/GPU - 24 tokens/sec

mistral-small3.2:24b
devstral-small-2:24b
- 32768: 20822 MB - 92 tokens/sec
- 40960: 22100 MB - 92 tokens/sec
- 49152: 23380 MB - 92 tokens/sec
- 65536: 25940 MB - 92 tokens/sec
- 90112: 29780 MB - 92 tokens/sec
- 98304: 31060 MB - 92 tokens/sec
- 106496: 5%/95% CPU/GPU - 45 tokens/sec

glm-4.7-flash:q4_K_M
- 32768: 22471 MB - 144 tokens/sec
- 65536: 25795 MB - 145 tokens/sec
- 98304: 29081 MB - 146 tokens/sec
- 114688: 30713 MB - 146 tokens/sec
- 122880: 31583 MB - 146 tokens/sec => too close
- 131071: 1%/99% CPU/GPU - 61 tokens/sec