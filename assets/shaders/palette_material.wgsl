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
    let dims = vec2<f32>(textureDimensions(uv_map_texture));

    let map_uv = uv - (uv % (1f/dims)) + (1f / (dims * 2f));

    let palette_uv = textureSample(
        uv_map_texture,
        uv_map_sampler,
        map_uv
    );

    let color = textureSample(
        palette_texture,
        palette_sampler,
        palette_uv.rg
    );

    return vec4<f32>(color.rgb, 1f);
}
