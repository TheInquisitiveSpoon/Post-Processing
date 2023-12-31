//--------------------------------------------------------------------------------------
// Colour Tint Post-Processing Pixel Shader
//--------------------------------------------------------------------------------------
// Just samples a pixel from the scene texture and multiplies it by a fixed colour to tint the scene

#include "Common.hlsli"


//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0); // We don't usually want to filter (bilinear, trilinear etc.) the scene texture when
                                          // post-processing so this sampler will use "point sampling" - no filtering

// This shader also uses a texture filled with noise
Texture2D    NoiseMap      : register(t1);
SamplerState TrilinearWrap : register(s1);


//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input) : SV_Target
{
	const float NoiseStrength = 0.5f; // How noticable the noise is

	// Get scene pixel colour and average r, g & b to get a single grey value
	float3 sceneColour = SceneTexture.Sample(PointSample, input.uv).rgb;
	float grey = sceneColour;

	// Get noise UV by scaling and offseting scene texture UV. Scaling adjusts how fine the noise is.
	// The offset is randomised every frame (in C++) to give a constantly changing noise effect (like tv static)
	float2 noiseUV = input.uv * gNoiseScale + gNoiseOffset;
	grey += NoiseStrength * (NoiseMap.Sample(TrilinearWrap, noiseUV).r - 0.5f); // Noise can increase or decrease grey value hence the -0.5f

	// Output final colour
	return float4(grey, grey, grey, 1.0f);
}