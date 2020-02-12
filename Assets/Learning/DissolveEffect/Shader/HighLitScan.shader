// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "XYS/HighLitScan"
{
	Properties
	{
		_Metallic("Metallic", Range( 0 , 1)) = 0.25
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.14
		_Color("Color", Color) = (0.9056604,0.9056604,0.9056604,0)
		_Diffuse("Diffuse", 2D) = "white" {}
		[HDR]_Highcolor("Highcolor", Color) = (0.8113208,0.8113208,0.8113208,0)
		_Width("Width", Range( 0 , 10)) = 5
		_Speed("Speed", Range( -10 , 10)) = 0
		_Direction("Direction", Range( 0 , 1)) = 1
		_HighLitTexture("HighLitTexture", 2D) = "white" {}
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform float4 _Color;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _Highcolor;
		uniform sampler2D _HighLitTexture;
		uniform float4 _HighLitTexture_ST;
		uniform float _Direction;
		uniform float _Speed;
		uniform float _Width;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			o.Albedo = ( _Color * tex2D( _Diffuse, uv_Diffuse ) ).rgb;
			float2 uv_HighLitTexture = i.uv_texcoord * _HighLitTexture_ST.xy + _HighLitTexture_ST.zw;
			float lerpResult11 = lerp( i.uv2_texcoord2.x , i.uv2_texcoord2.y , _Direction);
			float4 clampResult35 = clamp( ( _Highcolor * pow( ( tex2D( _HighLitTexture, uv_HighLitTexture ).r * sin( ( (0.0 + (lerpResult11 - 0.0) * (3.14 - 0.0) / (1.0 - 0.0)) + ( _Speed * _Time.y ) ) ) ) , exp( (10.0 + (_Width - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult35.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2637;201;1906;1010;4594.182;220.1749;1.019033;True;True
Node;AmplifyShaderEditor.RangedFloatNode;12;-4304,-32;Inherit;False;Property;_Direction;Direction;8;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-4262,-302;Inherit;True;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-4144,352;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;False;0;0;-2.13;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-4000,-208;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-4176,432;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-3727,67;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3936,400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-3584,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3920,592;Inherit;False;Property;_Width;Width;6;0;Create;True;0;0;False;0;5;7.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-3232,400;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-3264,144;Inherit;True;Property;_HighLitTexture;HighLitTexture;9;0;Create;True;0;0;False;0;-1;5798ded558355430c8a9b13ee12a847c;def60f835705efa41b4835b717701ef3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;26;-3479,775;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2789.887,300.7209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;22;-3188,791;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-2719.887,630.7208;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-2581.887,188.7208;Inherit;False;Property;_Highcolor;Highcolor;5;1;[HDR];Create;True;0;0;False;0;0.8113208,0.8113208,0.8113208,0;0.2780804,1.931927,2.79544,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2309.886,444.7209;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-2255.211,-352.1399;Inherit;True;Property;_Diffuse;Diffuse;3;0;Create;True;0;0;False;0;-1;aafe557eeb7160a47b641dd1dd1c22e5;5d513e5a40f4bae418bbfc5df6976c98;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-2224.226,-532.7561;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;False;0;0.9056604,0.9056604,0.9056604,0;0.875089,0.8874836,0.8962264,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1140.031,305.4505;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;False;0;0.14;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-1998.887,531.7205;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-1161.985,426.149;Inherit;True;Property;_Normal;Normal;4;1;[Normal];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-1187.838,209.5319;Inherit;False;Property;_Metallic;Metallic;0;0;Create;True;0;0;False;0;0.25;0.256;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1833.092,-405.3833;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-766.5867,193.656;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;XYS/HighLitScan;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;10;-1;-1;11;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;2
WireConnection;11;2;12;0
WireConnection;14;0;11;0
WireConnection;18;0;19;0
WireConnection;18;1;17;0
WireConnection;16;0;14;0
WireConnection;16;1;18;0
WireConnection;20;0;16;0
WireConnection;26;0;23;0
WireConnection;25;0;24;1
WireConnection;25;1;20;0
WireConnection;22;0;26;0
WireConnection;21;0;25;0
WireConnection;21;1;22;0
WireConnection;28;0;27;0
WireConnection;28;1;21;0
WireConnection;35;0;28;0
WireConnection;34;0;33;0
WireConnection;34;1;29;0
WireConnection;0;0;34;0
WireConnection;0;2;35;0
WireConnection;0;3;31;0
WireConnection;0;4;32;0
ASEEND*/
//CHKSM=825661601342E8D6A51C23E1BC2017CBDE784130