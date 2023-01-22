use bevy::{
    prelude::*,
    reflect::TypeUuid,
    render::render_resource::{AsBindGroup, ShaderRef}, sprite::{MaterialMesh2dBundle, Material2d, Material2dPlugin},
};


fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugin(Material2dPlugin::<PaletteMaterial>::default())
        .add_startup_system(setup)
        .run();
}

fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<PaletteMaterial>>,
    asset_server: Res<AssetServer>,
) {
    commands.spawn(Camera2dBundle::default());
    commands.spawn(MaterialMesh2dBundle {
        mesh: meshes.add(Mesh::from(shape::Quad::default())).into(),
        transform: Transform::default().with_scale(Vec3::splat(128.)),
        material: materials.add(PaletteMaterial::new(
            asset_server.load("images/palette.png"),
            asset_server.load("images/uv_map.png")
        )),
        ..default()
    });
}

#[derive(AsBindGroup, TypeUuid, Debug, Clone)]
#[uuid = "9600d1e3-1911-4286-9810-e9bd9ff685e1"]
pub struct PaletteMaterial {
    #[texture(0)]
    #[sampler(1)]
    palette: Option<Handle<Image>>,
    #[texture(2)]
    #[sampler(3)]
    uv_map: Option<Handle<Image>>,
}

impl PaletteMaterial {
    pub fn new(palette: Handle<Image>, uv_map: Handle<Image>) -> Self {
        Self {
            palette: Some(palette),
            uv_map: Some(uv_map)
        }
    }
}

impl Material2d for PaletteMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/palette_material.wgsl".into()
    }
}
