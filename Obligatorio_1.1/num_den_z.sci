/*
    phi_roots: vector 1 dim
    phi_poles: matrix nxn -> column1 = pole, column2 = pole gain
*/

function [num_z, den_z] = num_den_z(phi_roots, phi_poles)
    
    exec('./z_roots_poles.sci');
   
    roots_qty = length(phi_roots);
    poles_size = size(phi_poles);
    poles_qty = poles_size(1,1);
    
    //------------------------------------------
    //              Num
    //------------------------------------------
        z_roots = [];
        if roots_qty > 0 then
         for i = 1:roots_qty
             [z, z_conj] = z_roots_poles(phi_roots(i));
             if z == z_conj then
                 z_roots = [z_roots, z];
             else
                 z_roots = [z_roots, z];
                 z_roots = [z_roots, z_conj];
             end
         end
         num_z = poly(z_roots($:-1:1),'z','r');
        else
            num_z = 1;     
        end 
           
    //------------------------------------------
    //              Den
    //------------------------------------------
        z_poles = [];
        if poles_qty > 0 then
         for i = 1:poles_qty
             [z, z_conj] = z_roots_poles(phi_poles(i,1));
             z_poles = [z_poles, z*phi_poles(i,2)];
             if z ~= z_conj then
                 z_poles = [z_poles, z_conj*phi_poles(i,2)];
             end
         end
         den_z = poly(z_poles($:-1:1),'z','r');
        else
            den_z = 1;    
        end 

    //------------------------------------------
    //   Clean (calc errors and complex coeff.)
    //------------------------------------------        
        num_z = clean(real(num_z));
        den_z = clean(real(den_z));
  
endfunction
