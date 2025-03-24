# 1. Random variables
Các khái niệm:  
Hàm là gì?   
Biến là gì?  

Ω (omega) là Không gian mẫu, tất cả các sự kiện có thể xảy ra   
∩ là giao nhau  
∪ là hoặc, hợp  

event là tập con của Ω chứa một hoặc nhiều khả năng
probability là "xác xuất", là khả năng xảy ra của một event
![alt text](image.png)

a random variable is a numeric summary of the outcome of a random experiment (Biến ngẫu nhiên = là mapping một event thành một con số)  
Biến ngẫu nhiên luôn được viết bằng chữ in hoa (X,Y,...)

VD: X là số lượng con trai trong một gia đình có 3 con → X có thể nhận giá trị 0, 1, 2 hoặc 3.
![alt text](image-3.png)

Giá trị cụ thể của biến ngẫu nhiên được viết bằng chữ thường (ví dụ: x, y,...) là một con số

![alt text](image-4.png)
Dạng tổng quát: P(X = x), với x có thể là 0, 1, 2 hoặc 3.

Sự kiện (event) dùng dấu “∪” (or) và “∩” (and).
Xác suất (probability) của sự kiện dùng phép cộng (cho OR) hoặc nhân (cho AND nếu độc lập)

![alt text](image-5.png)
X ~ *Bin*(n, p)
![alt text](image-20.png)

# 2. Conditional probability
![alt text](image-6.png)
**The Multiplication Rule**:
![alt text](IMG_4025.jpeg)
![alt text](image-7.png)
Công thức Xác xuất có điều kiện: Xác suất của A trên điều kiện B sẽ bằng xác suất của A giao B chia cho xác suất của B.

Đổi không gian mẫu: P(A∩B)/P(B)=P(B∩A)/P(A)
![alt text](image-10.png)
Dấu "**,**" trong P(X=x, Y=y) nghĩa là "AND" hay "**∩**"
# 3. Bayes’ Theorem
![alt text](image-8.png)
![alt text](image-9.png)
Likelihood:   
Prior:  
Maginalization: thường dùng Partition theorem để tính  
Posterior:

# 4. Partition theorem
![alt text](image-11.png)
Áp dụng **Multiplication Rule**   
-> P(A) = P(A|B1)/P(B1) + P(A|B2)/P(B2) + P(A|B3)/P(B3) + P(A|B4)/P(B4)
![alt text](image-12.png)

### Bayes’ Theorem homework
1. Consider a test to detect a disease that 0.1 % of the population have. The test is 99 % effective in detecting an infected person.
However, the test gives a false positive result in 0.5 % of cases. If a person tests positive for the disease what is the probability that they actually have it?
![alt text](IMG_4030.jpeg)

2. It is estimated that 50% of emails are spam emails. Some software has been applied to filter these spam emails before they reach your inbox. A certain brand of software claims that it can detect 99% of spam emails, and the probability for a false positive (a non-spam email detected as spam) is 5%.
Now if an email is detected as spam, then what is the probability that it is in fact a non-spam email?
![alt text](IMG_4031.jpeg)

3. Early HIV Testing and Bayes’ Theorem
![alt text](image-16.png)
![alt text](IMG_4035.jpeg)
## Keep in mind!!!
![alt text](image-13.png)
![alt text](image-14.png)


# 5. Expectation and variance of a random variable
## **Expectation** is the *average* (*a fixed constant* with any size) of the **Ω**.  
**Average** is the mean of an **event** (*a random variable*).  
![alt text](image-19.png)
μ(X) = ∑x.fX(x) (probability function; FX(x): Cumulative Function)

![alt text](image-17.png)
![alt text](image-18.png)

Proof: E(X) = n*p
![alt text](IMG_4042.jpeg)

Properties of expectation
1. Expectation is a linear operator:
![alt text](image-21.png)
![alt text](image-28.png)

2. The expectation of a sum is the sum of the expectations:
![alt text](image-22.png)

![alt text](image-23.png)

3. Expectation of a product of random variables: E(XY)
![alt text](image-24.png)
![alt text](image-29.png)

4. Variable transformations:
![alt text](image-25.png)

5. Expected value of a transformed random variable:
![alt text](image-26.png)

Common mistakes in calculate expected value of a transformed random variable:
![alt text](image-27.png)  

## Variance
![alt text](image-30.png)
![alt text](image-31.png)

![alt text](image-32.png)

![alt text](image-33.png)

Properties of Variance
1. If *a* and *b* are constants and *g*(x) is a function, then:  
Part (i)
![alt text](image-34.png)
Part (ii)
![alt text](IMG_4043.jpeg)

2. Variance of a sum of random variables: Var(X + Y):
![alt text](image-35.png)

### Class task for Expectation and Variance:
![alt text](image-36.png)
![alt text](IMG_4044.jpeg)

# 6. Covariance
![alt text](image-37.png)

![alt text](image-38.png)

Example:
![alt text](image-39.png)
![alt text](IMG_4045.jpeg)

![alt text](image-40.png)
![alt text](IMG_4046.jpeg)

Theorem 2.19:
![alt text](image-41.png)

Theorem 2.20:
![alt text](image-42.png)

Theorem 2.22:
![alt text](image-43.png)

### Class task
![alt text](image-44.png)
![alt text](IMG_4053.jpeg)
Proof
![alt text](IMG_4054.jpeg)
# 7. Correlation
![alt text](image-46.png)
Theorem 2.23:
![alt text](image-50.png)

![alt text](image-49.png)
![alt text](image-48.png)
![alt text](image-47.png)

# 8. Probability as an Expectation:
![alt text](image-51.png)
**E(*I*A) = P(A)**
## Conditional probability:
![alt text](image-52.png)

# 9. Conditional Expectation:
![alt text](image-53.png)




# 10. Conditional Variance:
