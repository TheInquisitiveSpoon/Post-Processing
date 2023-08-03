#include "Common.hlsli"

Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0);

float4 main(PostProcessingInput input) : SV_Target
{
	float2 sampleCoords = input.uv;
	//sampleCoords.x += input.uv.y;
	//sampleCoords.x += lerp(0.0f, 1.0f, input.uv.y);

	//sampleCoords.x += lerp(0.0f, 0.1f, gRadians);
	//sampleCoords.y += lerp(-input.uv.x, gRadians);

	sampleCoords.x += lerp(0.0f, 0.1f, gRadians);

	//sampleCoords.x += lerp(0.0f, 0.1f, gRadians);
	//sampleCoords.y += sampleCoords.x + lerp(0.0f, 0.1f, gRadians); /*sin(gRadians);*/

	// WORKING:
	//sampleCoords.y += sin(gRadians);
	float3 colour = SceneTexture.Sample(PointSample, sampleCoords.xy).rgb * gWaterColour;

	// Got the RGB from the scene texture, set alpha to 1 for final output
	return float4(colour, 1.0f);
}