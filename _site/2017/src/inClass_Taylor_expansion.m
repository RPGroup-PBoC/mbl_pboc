% Define a range of x values to evaluate cos(x)
x = -4 * pi : 0.1 : 4 * pi;

% evaluate the actual function for comparison
y = cos(x);

% Let's evaluate the different order approximations
order_0 = ones([1, length(x)]);
order_2 = order_0 - x.^2 ./ factorial(2);
order_4 = order_2 + x.^4 ./ factorial(4);
order_6 = order_4 - x.^6 ./ factorial(6);
order_8 = order_6 + x.^8 ./ factorial(8);
order_10 = order_8 + x.^10 ./ factorial(10);
% Let's plot them all together

% initialize a figure
figure()
hold on
plot(x, y)
plot(x, order_0)
plot(x, order_2)
plot(x, order_4)
plot(x, order_6)
plot(x, order_8)
plot(x, order_10)

% pimp our plot
xlabel('x')
ylabel('y')
legend('cos(x)', '0th', '2nd', '4th', '6th', '8th', '10th')
ylim([-4, 4])

hold off













