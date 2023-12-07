RSRC                    VisualShader            ��������                                            /      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script 	   operator    parameter_name 
   qualifier    default_value_enabled    default_value    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_a3qq4 �      &   local://VisualShaderNodeColorOp_vypw0 6      -   local://VisualShaderNodeColorParameter_xbgfs �      !   local://VisualShaderNodeIf_ofwmy �         local://VisualShader_qq1v4          VisualShaderNodeInput             color          VisualShaderNodeColorOp                                                �̌?�̌?                  VisualShaderNodeColorParameter             enabled 
                  VisualShaderNodeIf             VisualShader          9  shader_type canvas_item;
render_mode blend_mix;

uniform vec4 enabled : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);



void fragment() {
// ColorParameter:5
	vec4 n_out5p0 = enabled;


// Input:2
	vec4 n_out2p0 = COLOR;


	vec3 n_out4p0;
// ColorOp:4
	vec3 n_in4p1 = vec3(0.00000, 1.10000, 1.10000);
	{
		float base = vec3(n_out2p0.xyz).x;
		float blend = n_in4p1.x;
		if (base < 0.5) {
			n_out4p0.x = (base * (2.0 * blend));
		} else {
			n_out4p0.x = (1.0 - (1.0 - base) * (1.0 - 2.0 * (blend - 0.5)));
		}
	}
	{
		float base = vec3(n_out2p0.xyz).y;
		float blend = n_in4p1.y;
		if (base < 0.5) {
			n_out4p0.y = (base * (2.0 * blend));
		} else {
			n_out4p0.y = (1.0 - (1.0 - base) * (1.0 - 2.0 * (blend - 0.5)));
		}
	}
	{
		float base = vec3(n_out2p0.xyz).z;
		float blend = n_in4p1.z;
		if (base < 0.5) {
			n_out4p0.z = (base * (2.0 * blend));
		} else {
			n_out4p0.z = (1.0 - (1.0 - base) * (1.0 - 2.0 * (blend - 0.5)));
		}
	}


	vec3 n_out6p0;
// If:6
	float n_in6p1 = 0.00000;
	float n_in6p2 = 0.00001;
	vec3 n_in6p3 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_in6p5 = vec3(0.00000, 0.00000, 0.00000);
	if(abs(n_out5p0.x - n_in6p1) < n_in6p2)
	{
		n_out6p0 = n_in6p3;
	}
	else if(n_out5p0.x < n_in6p1)
	{
		n_out6p0 = n_in6p5;
	}
	else
	{
		n_out6p0 = n_out4p0;
	}


// Output:0
	COLOR.rgb = n_out6p0;


}
    
   ��t�8���                      
     D  pB                
     ��  \C               
     �B  4C               
     �   �               
     �C  pB                                                                        RSRC