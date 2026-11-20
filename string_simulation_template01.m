function string_simulation_template01()
    close all
    num_masses = 3;
    total_mass = 10;
    tension_force = 1;
    string_length = 3;
    damping_coeff = 0.2;
    dx = string_length/(num_masses+1);
    amplitude_Uf = 3;
    omega_Uf = pi;

    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);
    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    %generate the struct
    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;
    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = [0; 1; 2];
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0;dUdt0];
   % tspan = [0 1];
    tlist = linspace(0, 200, 2000);
    %run the integration
    [tlist, Vlist] = ode45(my_rate_func,tlist,V0);
    tlist;
    figure;
    for i = 1:length(tlist)
        clf;
        title('Vibrating String Animation', 'Interpreter','Latex')
        xlabel('X Position (-)', 'Interpreter','Latex')
        ylabel('Y Position (-)', 'Interpreter','Latex')
        ylim([-2 2])
        xlim([0 3])
        
        x_vals = zeros(num_masses+2, 1);
        y_vals = zeros(num_masses+2, 1);
        x_vals(1) = 0;
        y_vals(1) = 0.5;
        x_vals(end) = string_length;
        y_vals(end) = 0.5;
        for j = 1:num_masses
            x = dx*j;
            x_vals(j+1) = x;
            y = Vlist(i, j);
            y_vals(j+1) = y;
            hold on
            plot(x, y, 'ro', Markersize=5, MarkerFaceColor='r')
        end
        plot(x_vals, y_vals, 'k', linewidth=2)
        drawnow;
    end

    % [tlist,Vlist] = your_integrator(my_rate_func,tspan,V0,...);
    %your code to generate an animation of the system
end