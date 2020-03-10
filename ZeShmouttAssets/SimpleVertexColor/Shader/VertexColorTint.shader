Shader "Custom/Vertex Color Tint"
{
	Properties
	{
		[PerRendererData] _DColor ("Base Color", Color) = (0,0,0,1)
		[PerRendererData] _DSmoothness ("Base Smoothness", Range(0,1)) = 0.0
		[PerRendererData] _DMetallic ("Base Metallic", Range(0,1)) = 0.0
		[PerRendererData] _DEmissiveColor ("Base Emissive Color", Color) = (0,0,0,1)
		[PerRendererData] _DEmissiveIntensity ("Base Emissive Intensity", float) = 1.0
		
		[PerRendererData] _RColor ("Red Color", Color) = (1,0,0,1)
		[PerRendererData] _RSmoothness ("Red Smoothness", Range(0,1)) = 0.0
		[PerRendererData] _RMetallic ("Red Metallic", Range(0,1)) = 0.0
		[PerRendererData] _REmissiveColor ("Red Emissive Color", Color) = (0,0,0,1)
		[PerRendererData] _REmissiveIntensity ("Red Emissive Intensity", float) = 1.0
		
		[PerRendererData] _GColor ("Green Color", Color) = (0,1,0,1)
		[PerRendererData] _GSmoothness ("Green Smoothness", Range(0,1)) = 0.0
		[PerRendererData] _GMetallic ("Green Metallic", Range(0,1)) = 0.0
		[PerRendererData] _GEmissiveColor ("Green Emissive Color", Color) = (0,0,0,1)
		[PerRendererData] _GEmissiveIntensity ("Green Emissive Intensity", float) = 1.0
		
		[PerRendererData] _BColor ("Blue Color", Color) = (0,0,1,1)
		[PerRendererData] _BSmoothness ("Blue Smoothness", Range(0,1)) = 0.0
		[PerRendererData] _BMetallic ("Blue Metallic", Range(0,1)) = 0.0
		[PerRendererData] _BEmissiveColor ("Blue Emissive Color", Color) = (0,0,0,1)
		[PerRendererData] _BEmissiveIntensity ("Blue Emissive Intensity", float) = 1.0
		
		[PerRendererData] _AColor ("Alpha Color", Color) = (1,1,1,1)
		[PerRendererData] _ASmoothness ("Alpha Smoothness", Range(0,1)) = 0.0
		[PerRendererData] _AMetallic ("Alpha Metallic", Range(0,1)) = 0.0
		[PerRendererData] _AEmissiveColor ("Alpha Emissive Color", Color) = (0,0,0,1)
		[PerRendererData] _AEmissiveIntensity ("Alpha Emissive Intensity", float) = 1.0
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		
		CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

		struct Input
		{
			float4 vertex : POSITION;
			float4 vertColor : COLOR;
			float3 viewDir;
		};

		fixed4 _DColor;
		half _DSmoothness;
		half _DMetallic;
		fixed4 _DEmissiveColor;
		half _DEmissiveIntensity;

		fixed4 _RColor;
		half _RSmoothness;
		half _RMetallic;
		fixed4 _REmissiveColor;
		half _REmissiveIntensity;

		fixed4 _GColor;
		half _GSmoothness;
		half _GMetallic;
		fixed4 _GEmissiveColor;
		half _GEmissiveIntensity;

		fixed4 _BColor;
		half _BSmoothness;
		half _BMetallic;
		fixed4 _BEmissiveColor;
		half _BEmissiveIntensity;

		fixed4 _AColor;
		half _ASmoothness;
		half _AMetallic;
		fixed4 _AEmissiveColor;
		half _AEmissiveIntensity;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			float baseMask = (1 - (IN.vertColor.r + IN.vertColor.g + IN.vertColor.b + IN.vertColor.a));
			
			float4 baseColor = baseMask * _DColor;
			float4 redColor = IN.vertColor.r * _RColor;
			float4 greenColor = IN.vertColor.g * _GColor;
			float4 blueColor = IN.vertColor.b * _BColor;
			float4 alphaColor = IN.vertColor.a * _AColor;
			float4 diffuse = baseColor + redColor + greenColor + blueColor + alphaColor;
			o.Albedo = saturate(diffuse);

			//float baseSmoothness = saturate(baseMask * _DSmoothness);
			//float redSmoothness = saturate(IN.vertColor.r * _RSmoothness);
			//float greenSmoothness = saturate(IN.vertColor.g * _GSmoothness);
			//float blueSmoothness = saturate(IN.vertColor.b * _BSmoothness);
			//float alphaSmoothness = saturate(IN.vertColor.a * _ASmoothness);
			//float gloss = baseSmoothness + redSmoothness + greenSmoothness + blueSmoothness + alphaSmoothness;
			//o.Smoothness = saturate(gloss);

			float baseSmoothness = _DSmoothness;
			float redSmoothness = lerp(baseSmoothness, _RSmoothness, IN.vertColor.r);
			float greenSmoothness = lerp(redSmoothness, _GSmoothness, IN.vertColor.g);
			float blueSmoothness = lerp(greenSmoothness, _BSmoothness, IN.vertColor.b);
			float alphaSmoothness = lerp(blueSmoothness, _ASmoothness, IN.vertColor.a);
			o.Smoothness = saturate(alphaSmoothness);

			//float baseMetallic = saturate(baseMask * _DMetallic);
			//float redMetallic = saturate(IN.vertColor.r * _RMetallic);
			//float greenMetallic = saturate(IN.vertColor.g * _GMetallic);
			//float blueMetallic = saturate(IN.vertColor.b * _BMetallic);
			//float alphaMetallic = saturate(IN.vertColor.a * _AMetallic);
			//float metal = baseMetallic + redMetallic + greenMetallic + blueMetallic + alphaMetallic;
			//o.Metallic = saturate(metal);

			float baseMetallic = _DMetallic;
			float redMetallic = lerp(baseMetallic, _RMetallic, IN.vertColor.r);
			float greenMetallic = lerp(redMetallic, _GMetallic, IN.vertColor.g);
			float blueMetallic = lerp(greenMetallic, _BMetallic, IN.vertColor.b);
			float alphaMetallic = lerp(blueMetallic, _AMetallic, IN.vertColor.a);
			o.Metallic = saturate(alphaMetallic);

			float4 baseEmissive = baseMask * _DEmissiveColor * _DEmissiveIntensity;
			float4 redEmissive = IN.vertColor.r * _REmissiveColor * _REmissiveIntensity;
			float4 greenEmissive = IN.vertColor.g * _GEmissiveColor * _GEmissiveIntensity;
			float4 blueEmissive = IN.vertColor.b * _BEmissiveColor * _BEmissiveIntensity;
			float4 alphaEmissive = IN.vertColor.a * _AEmissiveColor * _AEmissiveIntensity;
			float4 emissive = baseEmissive + redEmissive + greenEmissive + blueEmissive + alphaEmissive;
			o.Emission = emissive;
		}
		ENDCG
	}
	FallBack "Diffuse"
	CustomEditor "VertexColorTintGUI"
}