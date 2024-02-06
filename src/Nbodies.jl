using Plots

#initial Paramaeters
M = [10000, 200, 300, 400]
X = [0, 10, 15, 20]
Y = [0, 0, 0, 0]
Vx = [0, 0, 0, 0]
Vy = [0, 10, 20, 30]
dt = 0.01
dmin = 0.1
steps = 10000
#functions
function forces(X, Y, M)
    number = length(X)
    Fx = zeros(number)
    Fy = zeros(number)
    for i in 1:number-1
        for j in i+1:number
            fx = xforce(M[i], M[j], X[i], Y[i], X[j], Y[j])
            fy = yforce(M[i], M[j], X[i], Y[i], X[j], Y[j])
            Fx[i] += fx
            Fx[j] += -fx
            Fy[i] += fy
            Fy[j] += -fy
        end
    end
    return Fx, Fy
end

function xforce(m1, m2, x1, y1, x2, y2)
    if sqrt((x2 - x1)^2 + (y2 - y1)^2) > dmin
        return m1 * m2 / ((x2 - x1)^2 + (y2 - y1)^2)^(3/2) * (x2 - x1)
    else
        return m1 * m2 / (((x2 - x1) / abs(x2 - x1) * dmin)^2 + ((y2 - y1) / abs(y2 - y1) * dmin)^2)^(3/2) * ((x2 - x1) / abs(x2 - x1) * dmin)
    end
end

function yforce(m1, m2, x1, y1, x2, y2)
    if sqrt((x2 - x1)^2 + (y2 - y1)^2) > dmin
        return m1 * m2 / ((x2 - x1)^2 + (y2 - y1)^2)^(3/2) * (y2 - y1)
    else
        return m1 * m2 / (((x2 - x1) / abs(x2 - x1) * dmin)^2 + ((y2 - y1) / abs(y2 - y1) * dmin)^2)^(3/2) * ((y2 - y1) / abs(y2 - y1) * dmin)
    end
end

function time_step(X, Y, Vx, Vy, M, dt)
    X = X .+ Vx .* dt
    Y = Y .+ Vy .* dt
    Fx, Fy = forces(X, Y, M)
    Vx = Vx .+ Fx ./ M .* dt
    Vy = Vy .+ Fy ./ M .* dt
    return X, Y, Vx, Vy
end

anim = @animate for i in 1:1000
    global X, Y, Vx, Vy = time_step(X, Y, Vx, Vy, M, dt)
    scatter(X, Y, legend = false, xlims = (-50, 50), ylims = (-50, 50), aspect_ratio = 1)
end

gif(anim, fps = 50)
#for i in 1:steps
#    global X, Y, Vx, Vy = time_step(X, Y, Vx, Vy, M, dt)
#end
#scatter(X, Y, legend = false, xlims = (-300, 300), ylims = (-300, 300), aspect_ratio = 1)