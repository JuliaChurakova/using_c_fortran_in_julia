include("heading_Fortran.jl")
@F raw"""
function main()
real :: tim1,tim2
integer n, i,k,r
real (8) z,M ,c1,max
real (8), allocatable :: a(:,:)
real (8), allocatable :: x(:),c(:)
write(*,*) "введите n-размерность матрицы"
read(*,*) n
allocate (a(n,n+1))
allocate(x(n),c(n))
do i=1,n
a(i,i)=2*n
a(i,n+1)=n*(n+1)/2+i*(2*n-1)
end do

do i=1,n
do k=1,n
if (i/=k) a(i,k)=1
end do
end do
call cpu_time(tim1)
!прямой ход Гусса
do k=1,n
r=sum(maxloc(abs(a(1:k,k))))

c=a(k,:)
a(k,:)=a(r,:)
a(r,:)=c
!end do
!c1=b(k)
!b(k)=b(r)
!b(r)=c1
do i=k+1,n

M=a(i,k)/a(k,k)
a(i,:) = a(i,:) - M*a(k,:)
end do
end do


do k=n,1,-1
do i=k-1,1,-1
M=a(i,k)/a(k,k)
a(i,:)=a(i,:)-M*a(k,:)
enddo
a(k,n+1)=a(k,n+1)/a(k,k)
a(k,k)=1
enddo

!do i=n,1,-1
!z=0.0
!do j=i+1,n
!z=z+a(i,j)*x(j)
!end do
!x(i)= (a(i,n+1)-z)/a(i,i)
!end do
call cpu_time(tim2)
print *, "Время решения системы", tim2-tim1
write(*,*) "решение системы:"
!print *, x(1),x(n/2),x(n)
print *,a(1,n+1),a(n,n+1)
end
"""
