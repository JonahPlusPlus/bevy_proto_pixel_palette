@group(1) @binding(0)
var palette_texture: texture_2d<f32>;
@group(1) @binding(1)
var palette_sampler: sampler;

@group(1) @binding(2)
var uv_map_texture: texture_2d<f32>;
@group(1) @binding(3)
var uv_map_sampler: sampler;


@fragment
fn fragment(
    #import bevy_sprite::mesh2d_vertex_output
) -> @location(0) vec4<f32> {
    let uv_map_dims = vec2<f32>(textureDimensions(uv_map_texture));
    let palette_dims = vec2<f32>(textureDimensions(palette_texture));

    let uv_map_uv = uv - (uv % (1f/uv_map_dims)) + (1f / (uv_map_dims * 2f));

    let uv_map = textureSample(
        uv_map_texture,
        uv_map_sampler,
        uv_map_uv
    );

    let palette_uv = (uv_map.rg * 255f) + (vec2<f32>(0.5) / palette_dims);

    let color = textureSample(
        palette_texture,
        palette_sampler,
        palette_uv
    );

    return vec4<f32>(color.rgb, uv_map.a);
}
