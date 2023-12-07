RSRC                    VisualShader            ��������                                            .      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    parameter_name 
   qualifier    default_value_enabled    default_value    script    input_name    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        -   local://VisualShaderNodeColorParameter_d65pw �      /   local://VisualShaderNodeBooleanParameter_htfdn F      !   local://VisualShaderNodeIf_t732h �      $   local://VisualShaderNodeInput_thj34 �         local://VisualShader_li1qq 
         VisualShaderNodeColorParameter             tint          	      !   VisualShaderNodeBooleanParameter             enabled                   	         VisualShaderNodeIf              	         VisualShaderNodeInput    
         color 	         VisualShader          �  shader_type canvas_item;
render_mode blend_mix;

uniform bool enabled = true;
uniform vec4 tint : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);



void fragment() {
// BooleanParameter:3
	bool n_out3p0 = enabled;


// ColorParameter:2
	vec4 n_out2p0 = tint;


// Input:5
	vec4 n_out5p0 = COLOR;


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 0.00000;
	float n_in4p2 = 0.00001;
	if(abs((n_out3p0 ? 1.0 : 0.0) - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out2p0.xyz);
	}
	else if((n_out3p0 ? 1.0 : 0.0) < n_in4p1)
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}


// Output:0
	COLOR.rgb = n_out4p0;


}
    
   �6�B϶�                      
     �C  C                
     ��  �C               
     ��  �B               
     �C  C               
     �  �C                                                                              	      RSRC