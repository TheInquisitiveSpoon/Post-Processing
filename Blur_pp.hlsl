#include "Common.hlsli"

Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0);

float4 main(PostProcessingInput input) : SV_Target
{
	float xOffset = 50.0f / gViewportDimensions.x;
	float yOffset = 50.0f / gViewportDimensions.y;

	//float xOffset = 0.01f;
	//float yOffset = 0.01f;

	float3 center = SceneTexture.Sample(PointSample, input.uv).rgb;
	float3 top = SceneTexture.Sample(PointSample, input.uv + float2(0, -yOffset)).rgb;
	float3 bottom = SceneTexture.Sample(PointSample, input.uv + float2(0, yOffset)).rgb;
	float3 right = SceneTexture.Sample(PointSample, input.uv + float2(xOffset, 0)).rgb;
	float3 left = SceneTexture.Sample(PointSample, input.uv + float2(-xOffset, 0)).rgb;
	float3 colour = (center + center + top + bottom + left + right) / 6.0f;


	// Got the RGB from the scene texture, set alpha to 1 for final output
	return float4(colour, 1.0f);
}