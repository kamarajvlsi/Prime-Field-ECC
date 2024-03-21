p=int(input())
a=int(input())
b=int(input())
l=[]
for i in range(0,p):
    y=(i**2)%p;
    for j in range(0,p):
        x=((j*j*j)+(a*j)+b)%p;
        if y==x:
            l.append((j,i))
print(len(l))
print(l)
