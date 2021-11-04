/*
 
*/

function [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles)
    
    exec('./z_roots_poles.sci');
   
    roots_qty = length(phi_roots);
    poles_qty = length(phi_poles);
    
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
           
        num_z = num_z*low_gain; 
           
    //------------------------------------------
    //              Den
    //------------------------------------------
        z_poles = [];
        if poles_qty > 0 then
         for i = 1:poles_qty
             [z, z_conj] = z_roots_poles(phi_poles(i));
             if z == z_conj then
                 z_poles = [z_poles, z];
             else
                 z_poles = [z_poles, z];
                 z_poles = [z_poles, z_conj];
             end
         end
         den_z = poly(gain_poles($:-1:1).*z_poles($:-1:1),'z','r');
        else
            den_z = 1;    
        end 

    //------------------------------------------
    //              Clean (calc errors)
    //------------------------------------------        
    num_z = clean(num_z);
    den_z = clean(den_z);
  
endfunction
