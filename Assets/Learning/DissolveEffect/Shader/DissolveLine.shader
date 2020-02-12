// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "XYS/DissolveLine"
{
	Properties
	{
		_Metallic("Metallic", Range( 0 , 1)) = 0.25
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.14
		_Diffuse("Diffuse", 2D) = "white" {}
		_Direction("Direction", Range( 0 , 1)) = 1
		_Dissolve("Dissolve", Range( 0 , 10)) = 4.305836
		_Width("Width", Range( 0 , 15)) = 2.411765
		[Toggle]_Flip("Flip", Float) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (0.5189569,0.9042699,0.9245283,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float _Width;
		uniform float _Dissolve;
		uniform float _Flip;
		uniform float _Direction;
		uniform float4 _EdgeColor;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			o.Albedo = tex2D( _Diffuse, uv_Diffuse ).rgb;
			float lerpResult11 = lerp( i.uv2_texcoord2.x , i.uv2_texcoord2.y , _Direction);
			float temp_output_40_0 = ( _Dissolve * (( _Flip )?( (1.0 + (lerpResult11 - 0.0) * (0.1 - 1.0) / (1.0 - 0.0)) ):( (0.1 + (lerpResult11 - 0.0) * (1.0 - 0.1) / (1.0 - 0.0)) )) );
			float temp_output_43_0 = step( ( 0.5 - ( 0.05 * _Width ) ) , temp_output_40_0 );
			o.Emission = ( ( temp_output_43_0 - step( 0.5 , temp_output_40_0 ) ) * _EdgeColor ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( temp_output_43_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
163;163;1306;772;2130.619;394.7327;1.707798;True;True
Node;AmplifyShaderEditor.RangedFloatNode;12;-4481,-46;Inherit;False;Property;_Direction;Direction;4;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-4498,-424;Inherit;True;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-4165,-252;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-3176.533,-458.9326;Inherit;False;Constant;_Float3;Float 3;9;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2793.488,-84.98895;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-3233.533,-373.9326;Inherit;False;Property;_Width;Width;6;0;Create;True;0;0;False;0;2.411765;3.8;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;37;-3838.052,27.76971;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-3829,-146;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-2990.533,-504.9326;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;36;-3149.724,68.32709;Inherit;True;Property;_Flip;Flip;8;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3510.834,-284.9584;Inherit;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;False;0;4.305836;7.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;46;-2927.533,-292.9326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-2830.533,-393.9326;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3082.834,-98.95844;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;43;-2609.547,-241.7908;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;41;-2621.978,18.08008;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-2249.533,-93.93262;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-2282.251,139.8101;Inherit;False;Property;_EdgeColor;EdgeColor;9;1;[HDR];Create;True;0;0;False;0;0.5189569,0.9042699,0.9245283,0;1.035294,1.811765,1.85098,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;53;-2442.932,399.436;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;54;-2206.932,419.436;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1243.031,355.4505;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;False;0;0.14;0.549;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1975.251,35.81012;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;38;-3541.517,95.91187;Inherit;True;Property;_Keyword0;Keyword 0;7;0;Create;True;0;0;False;0;0;1;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-1458.19,-283.5588;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;False;0;0.9056604,0.9056604,0.9056604,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-1505.558,-78.36762;Inherit;True;Property;_Diffuse;Diffuse;3;0;Create;True;0;0;False;0;-1;None;1ebfc88998e12864cad4ff8891ed4eca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1094.361,-172.5692;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1246.838,259.5319;Inherit;False;Property;_Metallic;Metallic;0;0;Create;True;0;0;False;0;0.25;0.765;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-767.5867,176.656;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;XYS/DissolveLine;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;10;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;2
WireConnection;11;2;12;0
WireConnection;37;0;11;0
WireConnection;14;0;11;0
WireConnection;48;0;47;0
WireConnection;48;1;44;0
WireConnection;36;0;14;0
WireConnection;36;1;37;0
WireConnection;46;0;42;0
WireConnection;45;0;46;0
WireConnection;45;1;48;0
WireConnection;40;0;39;0
WireConnection;40;1;36;0
WireConnection;43;0;45;0
WireConnection;43;1;40;0
WireConnection;41;0;42;0
WireConnection;41;1;40;0
WireConnection;49;0;43;0
WireConnection;49;1;41;0
WireConnection;54;0;53;4
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;34;0;33;0
WireConnection;0;0;29;0
WireConnection;0;2;51;0
WireConnection;0;3;31;0
WireConnection;0;4;32;0
WireConnection;0;10;43;0
ASEEND*/
//CHKSM=A6FE0927F8BD06987BCE7835AF3262741A23194C