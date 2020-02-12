// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "XYS/PartHighLit"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 9.9
		_VertexBias("VertexBias", Range( 0 , 0.001)) = 0
		[HDR]_Highcolor("Highcolor", Color) = (0.8113208,0.8113208,0.8113208,0)
		_Width("Width", Range( 0 , 10)) = 5
		_HighLitTexture("HighLitTexture", 2D) = "white" {}
		_HorizontalVertical("Horizontal/Vertical", Range( 0 , 1)) = 1
		_Speed("Speed", Range( -10 , 10)) = 2.723853
		[Toggle]_ISDirControlBYMap("ISDirControlBYMap", Float) = 1
		_DirectionMap("DirectionMap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _VertexBias;
		uniform float4 _Highcolor;
		uniform sampler2D _HighLitTexture;
		uniform float4 _HighLitTexture_ST;
		uniform float _ISDirControlBYMap;
		uniform float _HorizontalVertical;
		uniform sampler2D _DirectionMap;
		uniform float4 _DirectionMap_ST;
		uniform float _Speed;
		uniform float _Width;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult37 = normalize( ase_vertexNormal );
			v.vertex.xyz += ( _VertexBias * normalizeResult37 );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_HighLitTexture = i.uv_texcoord * _HighLitTexture_ST.xy + _HighLitTexture_ST.zw;
			float lerpResult11 = lerp( i.uv_texcoord.x , i.uv_texcoord.y , _HorizontalVertical);
			float2 uv_DirectionMap = i.uv_texcoord * _DirectionMap_ST.xy + _DirectionMap_ST.zw;
			float clampResult35 = clamp( ( tex2D( _HighLitTexture, uv_HighLitTexture ).r * pow( sin( ( (0.0 + ((( _ISDirControlBYMap )?( tex2D( _DirectionMap, uv_DirectionMap ).r ):( lerpResult11 )) - 0.0) * (3.14 - 0.0) / (1.0 - 0.0)) + ( _Speed * _Time.y ) ) ) , exp( (10.0 + (_Width - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) ) ) , 0.0 , 1.0 );
			c.rgb = ( _Highcolor * clampResult35 ).rgb;
			c.a = ( _Highcolor.a * clampResult35 );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
958;327;1906;917;4277.904;492.4937;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-3900.376,-268.5445;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-3960.284,-9.327287;Inherit;False;Property;_HorizontalVertical;Horizontal/Vertical;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3808.674,-501.3104;Inherit;True;Property;_DirectionMap;DirectionMap;12;0;Create;True;0;0;False;0;-1;None;a9a3df69dcee83242ab85a06e44483a8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-3612.771,-200.5282;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-3657.329,260.5366;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;55;-3434.58,-343.0852;Inherit;False;Property;_ISDirControlBYMap;ISDirControlBYMap;11;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3638.238,164.2142;Inherit;False;Property;_Speed;Speed;10;0;Create;True;0;0;False;0;2.723853;-2;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3303.235,286.2478;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-4048.879,862.4468;Inherit;False;Property;_Width;Width;7;0;Create;True;0;0;False;0;5;9;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-3052.615,-129.4442;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-3106.914,246.4612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-3705.879,853.4468;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;22;-3476.879,846.4468;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-2911.961,146.6101;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-3031.194,733.4937;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-2749.317,-93.51501;Inherit;True;Property;_HighLitTexture;HighLitTexture;8;0;Create;True;0;0;False;0;-1;None;51573762f8e184249b7de757de64e14d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2323.118,6.324034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;36;-1370.933,663.9608;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-1312.265,568.7474;Inherit;False;Property;_VertexBias;VertexBias;5;0;Create;True;0;0;False;0;0;0;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-2078.85,170.5958;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-2072.23,-21.98801;Inherit;False;Property;_Highcolor;Highcolor;6;1;[HDR];Create;True;0;0;False;0;0.8113208,0.8113208,0.8113208,0;0.5803922,1.223529,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;37;-1140.933,677.9608;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1685.2,445.8496;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-992.2649,551.7474;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1613.706,109.0146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-766.5867,193.656;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;XYS/PartHighLit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;9.9;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;2
WireConnection;11;2;12;0
WireConnection;55;0;11;0
WireConnection;55;1;54;1
WireConnection;18;0;19;0
WireConnection;18;1;17;0
WireConnection;14;0;55;0
WireConnection;16;0;14;0
WireConnection;16;1;18;0
WireConnection;26;0;23;0
WireConnection;22;0;26;0
WireConnection;20;0;16;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;25;0;24;1
WireConnection;25;1;21;0
WireConnection;35;0;25;0
WireConnection;37;0;36;0
WireConnection;56;0;27;0
WireConnection;56;1;35;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;57;0;27;4
WireConnection;57;1;35;0
WireConnection;0;9;57;0
WireConnection;0;13;56;0
WireConnection;0;11;39;0
ASEEND*/
//CHKSM=93F6534DA9D4427944901F5F10161E9101294845