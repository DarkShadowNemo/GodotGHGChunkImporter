@tool
extends EditorImportPlugin
class_name MAINghg_

#outdated

"""# GHG

## File Header

|Address|Data Type|Definition|Extra Information|
|---|---|---|---|
|0x0|Dword|File Size|Inclusive|
|0x8|Dword|||
|0xC|Dword*|Pointer Usually To 0x90||
|0x10|Dword|||
|0x14|Dword*|Pointer To Section B?||
|0x1C|Dword*|Pointer To Bones?||
|0x20|Dword*|Pointer To Section C?||
|0x24|Dword*|???||
|0x4C|Dword*|Pointer To Objects Header||
|0x90|Dword*|Pointer To Textures Header||"""

#updated

## File Header
"""|Address|Data Type|Definition|Extra Information|
|---|---|---|---|
|0x0|Dword|File Size|Inclusive|
|0x4|Dword|Zero1||
|0x8|Dword|TextureCount||
|0xC|Dword|Dword*|Pointer Usually To 0x90||
|0x10|Dword|MaterialCount||
|0x14|Dword|Dword*|Pointer Usually To 0x90 bu no always||
|0x18|Dword|BoneCount||
|0x1C|Dword*|Pointer To rotsclMatrix||
|0x20|Dword*|Pointer To sclposMatrix||
|0x24|Dword*|Pointer To RealposMatrix||
|0x28|Dword|ObjectCount||
|0x2C|Dword*|Pointer To ObjectMatrix||
|0x30|Dword*|Pointer To NamedTable||
|0x34|Dword*|NamedTableLength||
etc
"""

### Texture
"""TIM2 Headerless PQRS Format
|Address|Data Type|Definition|Extra Information|
|---|---|---|---|
|0x0|Word|File Size|Inclusive|
|0x2|DWord|Type1||
|0x4|Dword|Height||
|0x6|Dword|Type2||
|0x8|Dword|Pitch||
"""




var root_node = Node3D.new()


func _main_ghg_1_(file : FileAccess, source_file : String):
	file.seek(0)
	
	var faces4=[]
	var faces5=[]
	var faces6=[]
	
	var faces4a=[]
	var faces5a=[]
	var faces6a=[]
	
	var flgidx = 0
	var flgidx2 = 0
	
	var taridx = 0
	
	var uvscales = 0.0000
	var vcolScales = 0.0000
	
	var vertices : PackedVector3Array
	var faces : PackedVector3Array
	var normals : PackedVector3Array
	var uvs : PackedVector2Array
	
	var vertices2 : PackedVector3Array
	var faces2 : PackedVector3Array
	
	var immeediate_mesh_ := MeshInstance3D.new()
	var immeediate_mesh2_ := MeshInstance3D.new()
	
	var array_mesh : ArrayMesh = null
	var array_mesh2 : ArrayMesh = null
	
	var surf_tool : SurfaceTool
	var surf_tool2 : SurfaceTool
	
	surf_tool = SurfaceTool.new()
	surf_tool2 = SurfaceTool.new()
	
	var mat01 = StandardMaterial3D.new()
	mat01.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	var mat02 = StandardMaterial3D.new()
	mat02.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	
	
	
	while file.get_position() < file.get_length():
		var Chunk = file.get_32()
		if Chunk == int(16777731):
			var unk01 = file.get_8()
			var unk02 = file.get_8()
			var vertexCount = file.get_8()/2
			var flags2 = file.get_8()
			
			var fa=-1
			var fb=0
			var fc=1
			
			
			var faa=-3
			var fbb=-2
			var fcc=-1
			
			
			
			
			vertices.resize(vertexCount)
			faces.resize(vertexCount)
			uvs.resize(vertexCount)
			normals.resize(vertexCount)
			surf_tool2.begin(Mesh.PRIMITIVE_TRIANGLES)
			if flags2 == int(109):
				flgidx2+=1
				if flgidx2 <= int(256):
					if vertexCount == 3:
						for jj in range(vertexCount):
							var vx1a = file.get_16()
							var vy1a = file.get_16()
							var vz1a = file.get_16()
							var nzf = file.get_16()
							var uvx = file.get_16()
							var uvy = file.get_16()
							file.get_32()
							
							var vx1 = vx1a
							var vy1 = vy1a
							var vz1 = vz1a
							
							vx1 /= float(vx1a/4096)
							vy1 /= float(vx1a/4096)
							vz1 /= float(vz1a/4096)
							#surf_tool2.set_uv(Vector2(float(uvx)/4096,float(-uvy)/4096))
							surf_tool2.add_vertex(Vector3(vx1,vy1,vz1))
						for jja in range(vertexCount-2):
							faa+=1*3
							fbb+=1*3
							fcc+=1*3
							surf_tool2.add_index(faa)
							surf_tool2.add_index(fbb)
							surf_tool2.add_index(fcc)
				array_mesh2 = surf_tool2.commit(array_mesh2)
	
	immeediate_mesh2_.mesh = array_mesh2
	immeediate_mesh2_.name = "ghg 2 pt 1"
	root_node.add_child(immeediate_mesh2_)
	immeediate_mesh2_.owner = root_node
