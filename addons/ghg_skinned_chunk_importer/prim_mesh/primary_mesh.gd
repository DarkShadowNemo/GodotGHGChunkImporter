@tool
extends EditorImportPlugin
class_name PRIMARY_MESH_1a

var root_node = Node3D.new()

const SEEK_SET := 0
const SEEK_CUR := 1
const SEEK_END := 2


func custom_seek(file: FileAccess, offset: int, whence: int) -> void:
	var new_pos := 0
	match whence:
		SEEK_SET:
			new_pos = offset
		SEEK_CUR:
			new_pos = file.get_position() + offset
		SEEK_END:
			new_pos = file.get_length() + offset
		_:
			push_error("Invalid whence value")
			return
	new_pos = clamp(new_pos, 0, file.get_length())
	
	file.seek(new_pos)

func u8_to_s8(u8: int) -> int:
	u8 &= 0xFF
	if u8 & 0x80:
		return u8 - 0x100
	return u8
		
func u16_to_s16(u16: int) -> int:
	u16 &= 0xFFFF
	if u16 > 0x7FFF:
		return u16 - 0x10000
	return u16
	
func s16_to_float(s16_value: int) -> float:
	if s16_value & 0x8000:  # If sign bit is set
		s16_value -= 0x10000  # Convert to negative value
	return float(s16_value) / 4096.0

func _primary_mesh_(file : FileAccess, source_file : String):
	
	var matsizee=[]
	var texsizee=[]
	
	var materials1=[]
	var materials2=[]
	var materials3=[]
	
	var faces4=[]
	var faces5=[]
	var faces6=[]
	
	var faces4a=[]
	var faces5a=[]
	var faces6a=[]
	
	var flgidx = 0
	var flgidx2 = 0
	var flgidx3 = 0
	
	var taridx = 0
	
	var uvscales = 0.0000
	var vcolScales = 0.0000
	
	var vertices : PackedVector3Array
	var faces : PackedVector3Array
	var normals : PackedVector3Array
	var uvs : PackedVector2Array
	
	var vertices2 : PackedVector3Array
	var faces2 : PackedVector3Array
	var normals2 : PackedVector3Array
	var uvs2 : PackedVector2Array
	
	var vertices3 : PackedVector3Array
	var faces3 : PackedVector3Array
	var normals3 : PackedVector3Array
	var uvs3 : PackedVector2Array
	
	var immeediate_mesh_ := MeshInstance3D.new()
	var immeediate_mesh2_ := MeshInstance3D.new()
	var immeediate_mesh3_ := MeshInstance3D.new()
	
	var array_mesh : ArrayMesh = null
	var array_mesh2 : ArrayMesh = null
	var array_mesh3 : ArrayMesh = null
	
	var surf_tool : SurfaceTool
	var surf_tool2 : SurfaceTool
	var surf_tool3 : SurfaceTool
	
	surf_tool = SurfaceTool.new()
	surf_tool2 = SurfaceTool.new()
	surf_tool3 = SurfaceTool.new()
	
	var mat01 = StandardMaterial3D.new()
	mat01.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	var mat02 = StandardMaterial3D.new()
	mat02.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat02.vertex_color_use_as_albedo = true
	
	var mat03 = StandardMaterial3D.new()
	mat03.cull_mode = BaseMaterial3D.CULL_DISABLED
	file.seek(0)
	
	var FileSize = file.get_32()
	var null01 = file.get_32()
	var texturecount = file.get_32()
	var texturesize1 = file.get_32()
	var mateialcount = file.get_32()
	var matsize1 = file.get_32()
	var BoneCount = file.get_32()
	var bonesize1 = file.get_32()
	var bonesize2 = file.get_32()
	var bonesize3 = file.get_32()
	var null02 = file.get_32()
	var sizze3= file.get_32()
	var namedtablesize1= file.get_32()
	var namedtablelengh= file.get_32()
	var count1 = file.get_32()
	var size1 = file.get_32()
	var count2 = file.get_32()
	var size2 = file.get_32()
	var defaultlayercount = file.get_32()
	var defaultlayersize1 = file.get_32()
	var endsize1a = file.get_32()
	for i in range(11):
		var float01 = file.get_float()
		float01-=float01
	var size1AA = file.get_32()
	var floatcount1= file.get_float()
	var type01 = file.get_32()
	var endsize1aa = file.get_32()
	if texturecount == 0:
		if matsize1 == 148:
			var entrysizeExtra1=file.get_32()
		elif matsize1 == 152:
			var entrysizeExtra1=file.get_32()
			var entrysizeExtra2=file.get_32()
		file.seek(matsize1)
		for i in range(mateialcount):
			var matsizelist1 = file.get_32()
			matsizee.append(matsizelist1)
		file.seek(matsizee[0])
		for i in range(mateialcount):
			
			custom_seek(file,288,1)
			custom_seek(file,96,1)
			var red = file.get_float()
			var green = file.get_float()
			var blue = file.get_float()
			custom_seek(file,28,1)
			var matid = file.get_32()
			custom_seek(file,36,1)
			materials1.append(red)
			materials2.append(green)
			materials3.append(blue)
		var bna=[]
		var stack=[]
	
		var bone_names = []
	
		var iddx1
		
		var bonename = "%s" % iddx1
		
		var boncount = Skeleton3D.new()
		boncount.name = "GHG Armature"
		root_node.add_child(boncount)
		boncount.owner = root_node
		for i in range(BoneCount):
			boncount.add_bone("%s" % i)
		file.seek(bonesize1)
		for i in range(BoneCount):
			custom_seek(file,64,1)
			custom_seek(file,16,1)
			var parent_id = file.get_8()
			var s_idx : int=u8_to_s8(parent_id)
			custom_seek(file,15,1)
			boncount.set_bone_parent(i,s_idx)
		file.seek(bonesize3)
		
		var xposx=0
		var yposy=0
		var zposz=0
		var idx1a=-1
		
		var nposx=0
		var nposy=0
		var nposz=0
			
		for i in range(BoneCount):
			var ScaleX = file.get_float()
			var rotationz = file.get_float()
			var rotationy = file.get_float()
			var null1 = file.get_float()
			var nrotationz = file.get_float()
			var ScaleY = file.get_float()
			var rotationx = file.get_float()
			var nrotationy = file.get_float()
			var null2 = file.get_float()
			var nrotationx = file.get_float()
			var ScaleZ = file.get_float()
			var null3 = file.get_float()
			var posx = -file.get_float()
			var posy = -file.get_float()
			var posz = -file.get_float()
			var ScaleW = file.get_float()
			
			boncount.set_bone_pose_position(i, Vector3(ScaleX-ScaleX+posx*ScaleX,ScaleY-ScaleY+posy*ScaleY,ScaleZ-ScaleZ+-posz*ScaleZ))
		
			boncount.set_bone_pose_scale(i,Vector3(1,1,1))
			
		file.seek(0)
	
		
		
		if mateialcount == 0:
			pass
		elif mateialcount == 1:
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777731):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCountb = file.get_8()/2
					var flagsa1 = file.get_8()
					
					
					var faa=-3
					var fbb=-2
					var fcc=-1
					
					var faa1=-1
					var fbb1=-4
					var fcc1=-3
					var fdd1=-2
					
					var faces1=[]
					
					
					
					
					vertices3.resize(vertexCountb)
					faces3.resize(vertexCountb)
					uvs3.resize(vertexCountb)
					normals3.resize(vertexCountb)
					surf_tool3.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flagsa1 == int(109):
						flgidx+=1
						
						if flgidx <= int(256):
							if vertexCountb == int(3):
								for j in range(vertexCountb):
									var vx3 = file.get_16()
									var vy3 = file.get_16()
									var vz3 = file.get_16()
									var nz3 = file.get_16()
									var uvx3 = file.get_16()
									var uvy3 = file.get_16()
									var unkk = file.get_32()
									
									var signed_vx: int = u16_to_s16(vx3)
									var signed_vy: int = u16_to_s16(vy3)
									var signed_vz: int = u16_to_s16(vz3)
									
									var signed_uvx: int = u16_to_s16(uvx3)
									var signed_uvy: int = u16_to_s16(uvy3)
									
									var ssigned_vx = float(signed_vx)/4096
									var ssigned_vy = float(signed_vy)/4096
									var ssigned_vz = float(signed_vz)/4096
									
									var ssigned_uvx = float(signed_uvx)/4096
									var ssigned_uvy = float(signed_uvy)/4096
									
									var ssigned_vxx = snapped(ssigned_vx,0.001)
									var ssigned_vyy = snapped(ssigned_vy,0.001)
									var ssigned_vzz = snapped(ssigned_vz,0.001)
									
									
									
									
									surf_tool3.set_uv(Vector2(ssigned_uvx,-ssigned_uvy))
									surf_tool3.add_vertex(Vector3(ssigned_vxx,ssigned_vyy,-ssigned_vzz))
								custom_seek(file,78,1)
								var faceCount = file.get_8()
								var flg1 = file.get_8()
								if flg1 == int(110):
									if faceCount == int(1):
										for i in range(vertexCountb-2):
											faa+=1*3
											fbb+=1*3
											fcc+=1*3
											
											surf_tool3.add_index(faa)
											surf_tool3.add_index(fbb)
											surf_tool3.add_index(fcc)
									
									
								
							
									
								
						surf_tool3.generate_normals(true)
						surf_tool3.set_material(mat03)
					array_mesh3 = surf_tool3.commit(array_mesh3)
		
		
		
			file.seek(0)
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777475):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCount = file.get_8()
					var flags1 = file.get_8()
					
					var fa=-1
					var fb=0
					var fc=1
					
					
					var faa=-1
					var fbb=0
					var fcc=1
					
					
					
					
					vertices.resize(vertexCount)
					faces.resize(vertexCount)
					uvs.resize(vertexCount)
					normals.resize(vertexCount)
					surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flags1 == int(108):
						flgidx+=1
						
						if flgidx <= int(256):
							for j in range(vertexCount):
								#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
								#var nz = file.get_float()
								var vx = file.get_float()
								var vy = file.get_float()
								var vz = file.get_float()
								var type4 = file.get_8()
								var value1 = file.get_8()
								var normalZ = file.get_16()
								
								var vx1 = vx
								var vy1 = vy
								var vz1 = vz
								
								var vxa = snapped(vx,0.001)
								var vya = snapped(vy,0.001)
								var vza = snapped(vz,0.001)
								
								if vx >= float(10000) and vy >= float(10000) and vz >= float(10000) or vx <= float(-10000) and vy <= float(-10000) and vz <= float(-10000):
									vx1-=vx1
									vy1-=vy1
									vz1-=vz1
								surf_tool.add_vertex(Vector3(vxa,vya,-vza))
								var type5 = type4==0
								fa+=1
								fb+=1
								fc+=1
								if type5:
									faces4=j+j+type4-type4-1+fa-j-j-1+j%2
									faces5=j-j+type4-type4+1+fb-2-1+j-j-j%2
									faces6=j+type4-type4+fc-j+2-4
									var a1=faces4
									var b1=faces5
									var c1=faces6

									surf_tool.add_index(a1)
									surf_tool.add_index(b1)
									surf_tool.add_index(c1)
									
						surf_tool.generate_normals(true)
						surf_tool.set_material(mat01)
						mat01.albedo_color=Color(materials1[0],materials2[0],materials3[0])
						mat01.metallic_specular=0
						mat01.roughness=1
					array_mesh = surf_tool.commit(array_mesh)
						
					
			
			
			file.seek(0)
			
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777732):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCounta = file.get_8()/2
					var flagsa1 = file.get_8()
					
					if vertexCounta:
					
					
						var faa=-1
						var fbb=0
						var fcc=1
						
						
						
						
						vertices2.resize(vertexCounta)
						faces2.resize(vertexCounta)
						uvs2.resize(vertexCounta)
						normals2.resize(vertexCounta)
						
						
						surf_tool2.begin(Mesh.PRIMITIVE_TRIANGLES)
						
						#var faces = [[0,1,2]]
						if flagsa1 == int(108):
							flgidx+=1
							
							if flgidx <= int(256):
								for j in range(vertexCounta):
									#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
									#var nz = file.get_float()
									var vx2 = file.get_float()
									var vy2 = file.get_float()
									var vz2 = file.get_float()
									var brightness = file.get_float()
									var uvx2 = file.get_float()
									var uvy2 = file.get_float()
									var unkk = file.get_float()
									var type4 = file.get_8()
									var value1 = file.get_8()
									var normalZ = file.get_16()
									
									var vx1 = vx2
									var vy1 = vy2
									var vz1 = vz2
									
									var vx2a = snapped(vx2,0.001)
									var vy2a = snapped(vy2,0.001)
									var vz2a = snapped(vz2,0.001)
									if vx2 >= float(10000) and vy2 >= float(10000) and vz2 >= float(10000) or vx2 <= float(-10000) and vy2 <= float(-10000) and vz2 <= float(-10000):
										vx1-=vx1
										vy1-=vy1
										vz1-=vz1
									surf_tool2.set_color(Color(float(brightness),float(brightness),float(brightness),float(1)))
									surf_tool2.set_uv(Vector2(uvx2,-uvy2))
									surf_tool2.add_vertex(Vector3(vx2a,vy2a,-vz2a))
									var type5 = type4==0
									faa+=1
									fbb+=1
									fcc+=1
									if type5:
										faces4a=j+j+type4-type4-1+faa-j-j-1+j%2
										faces5a=j-j+type4-type4+1+fbb-2-1+j-j-j%2
										faces6a=j+type4-type4+fcc-j+2-4
										var a12=faces4a
										var b12=faces5a
										var c12=faces6a
				

										surf_tool2.add_index(a12)
										surf_tool2.add_index(b12)
										surf_tool2.add_index(c12)
										
								surf_tool2.generate_normals(true)
								surf_tool2.set_material(mat02)
								array_mesh2 = surf_tool2.commit(array_mesh2)
								
		elif mateialcount != 0:
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777731):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCountb = file.get_8()/2
					var flagsa1 = file.get_8()
					
					
					var faa=-3
					var fbb=-2
					var fcc=-1
					
					var faa1=-1
					var fbb1=-4
					var fcc1=-3
					var fdd1=-2
					
					var faces1=[]
					
					
					
					
					vertices3.resize(vertexCountb)
					faces3.resize(vertexCountb)
					uvs3.resize(vertexCountb)
					normals3.resize(vertexCountb)
					surf_tool3.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flagsa1 == int(109):
						flgidx+=1
						
						if flgidx <= int(256):
							if vertexCountb == int(3):
								for j in range(vertexCountb):
									var vx3 = file.get_16()
									var vy3 = file.get_16()
									var vz3 = file.get_16()
									var nz3 = file.get_16()
									var uvx3 = file.get_16()
									var uvy3 = file.get_16()
									var unkk = file.get_32()
									
									var signed_vx: int = u16_to_s16(vx3)
									var signed_vy: int = u16_to_s16(vy3)
									var signed_vz: int = u16_to_s16(vz3)
									
									var signed_uvx: int = u16_to_s16(uvx3)
									var signed_uvy: int = u16_to_s16(uvy3)
									
									var ssigned_vx = float(signed_vx)/4096
									var ssigned_vy = float(signed_vy)/4096
									var ssigned_vz = float(signed_vz)/4096
									
									var ssigned_uvx = float(signed_uvx)/4096
									var ssigned_uvy = float(signed_uvy)/4096
									
									var ssigned_vxx = snapped(ssigned_vx,0.001)
									var ssigned_vyy = snapped(ssigned_vy,0.001)
									var ssigned_vzz = snapped(ssigned_vz,0.001)
									
									
									
									
									surf_tool3.set_uv(Vector2(ssigned_uvx,-ssigned_uvy))
									surf_tool3.add_vertex(Vector3(ssigned_vxx,ssigned_vyy,-ssigned_vzz))
								custom_seek(file,78,1)
								var faceCount = file.get_8()
								var flg1 = file.get_8()
								if flg1 == int(110):
									if faceCount == int(1):
										for i in range(vertexCountb-2):
											faa+=1*3
											fbb+=1*3
											fcc+=1*3
											
											surf_tool3.add_index(faa)
											surf_tool3.add_index(fbb)
											surf_tool3.add_index(fcc)
									
									
								
							
									
								
						surf_tool3.generate_normals(true)
						surf_tool3.set_material(mat03)
					array_mesh3 = surf_tool3.commit(array_mesh3)
		
		
		
			file.seek(0)
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777475):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCount = file.get_8()
					var flags1 = file.get_8()
					
					var fa=-1
					var fb=0
					var fc=1
					
					
					var faa=-1
					var fbb=0
					var fcc=1
					
					
					
					
					vertices.resize(vertexCount)
					faces.resize(vertexCount)
					uvs.resize(vertexCount)
					normals.resize(vertexCount)
					surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flags1 == int(108):
						flgidx+=1
						
						if flgidx <= int(256):
							for j in range(vertexCount):
								#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
								#var nz = file.get_float()
								var vx = file.get_float()
								var vy = file.get_float()
								var vz = file.get_float()
								var type4 = file.get_8()
								var value1 = file.get_8()
								var normalZ = file.get_16()
								
								var vx1 = vx
								var vy1 = vy
								var vz1 = vz
								
								var vxa = snapped(vx,0.001)
								var vya = snapped(vy,0.001)
								var vza = snapped(vz,0.001)
								
								if vx >= float(10000) and vy >= float(10000) and vz >= float(10000) or vx <= float(-10000) and vy <= float(-10000) and vz <= float(-10000):
									vx1-=vx1
									vy1-=vy1
									vz1-=vz1
								surf_tool.add_vertex(Vector3(vxa,vya,-vza))
								var type5 = type4==0
								fa+=1
								fb+=1
								fc+=1
								if type5:
									faces4=j+j+type4-type4-1+fa-j-j-1+j%2
									faces5=j-j+type4-type4+1+fb-2-1+j-j-j%2
									faces6=j+type4-type4+fc-j+2-4
									var a1=faces4
									var b1=faces5
									var c1=faces6

									surf_tool.add_index(a1)
									surf_tool.add_index(b1)
									surf_tool.add_index(c1)
									surf_tool.add_index(b1)
									surf_tool.add_index(b1)
									surf_tool.add_index(c1)
							var offset1 = file.get_16()
							if offset1 == 1:
								custom_seek(file,4,1)
								var uvcount1 = file.get_8()
								var uvflg = file.get_8()
								if uvflg == 109:
									custom_seek(file, uvcount1*8,1)
									var offset2 = file.get_16()
									if offset2 == 0:
										custom_seek(file,4,1)
										var vcolcount = file.get_8()
										var vcolflg = file.get_8()
										if vcolflg == 110:
											custom_seek(file,vcolcount*4,1)
											var offset1a = file.get_32()
											if offset1a == 16777473:
												var offset2a = file.get_32()
												if offset2a == 335545088:
													if file.get_position() == 12660:
														mat01.albedo_color=Color(materials1[0],materials2[0],materials3[0])
														mat01.metallic_specular=0
														mat01.roughness=1
														break
									
									
						surf_tool.generate_normals(true)
						surf_tool.set_material(mat01)
					array_mesh = surf_tool.commit(array_mesh)
					
						
					
			
			
			file.seek(0)
			
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777732):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCounta = file.get_8()/2
					var flagsa1 = file.get_8()
					
					if vertexCounta:
					
					
						var faa=-1
						var fbb=0
						var fcc=1
						
						
						
						
						vertices2.resize(vertexCounta)
						faces2.resize(vertexCounta)
						uvs2.resize(vertexCounta)
						normals2.resize(vertexCounta)
						
						
						surf_tool2.begin(Mesh.PRIMITIVE_TRIANGLES)
						
						#var faces = [[0,1,2]]
						if flagsa1 == int(108):
							flgidx+=1
							
							if flgidx <= int(256):
								for j in range(vertexCounta):
									#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
									#var nz = file.get_float()
									var vx2 = file.get_float()
									var vy2 = file.get_float()
									var vz2 = file.get_float()
									var brightness = file.get_float()
									var uvx2 = file.get_float()
									var uvy2 = file.get_float()
									var unkk = file.get_float()
									var type4 = file.get_8()
									var value1 = file.get_8()
									var normalZ = file.get_16()
									
									var vx1 = vx2
									var vy1 = vy2
									var vz1 = vz2
									
									var vx2a = snapped(vx2,0.001)
									var vy2a = snapped(vy2,0.001)
									var vz2a = snapped(vz2,0.001)
									if vx2 >= float(10000) and vy2 >= float(10000) and vz2 >= float(10000) or vx2 <= float(-10000) and vy2 <= float(-10000) and vz2 <= float(-10000):
										vx1-=vx1
										vy1-=vy1
										vz1-=vz1
									surf_tool2.set_color(Color(float(brightness),float(brightness),float(brightness),float(1)))
									surf_tool2.set_uv(Vector2(uvx2,-uvy2))
									surf_tool2.add_vertex(Vector3(vx2a,vy2a,-vz2a))
									var type5 = type4==0
									faa+=1
									fbb+=1
									fcc+=1
									if type5:
										faces4a=j+j+type4-type4-1+faa-j-j-1+j%2
										faces5a=j-j+type4-type4+1+fbb-2-1+j-j-j%2
										faces6a=j+type4-type4+fcc-j+2-4
										var a12=faces4a
										var b12=faces5a
										var c12=faces6a
				

										surf_tool2.add_index(a12)
										surf_tool2.add_index(b12)
										surf_tool2.add_index(c12)
										
								surf_tool2.generate_normals(true)
								surf_tool2.set_material(mat02)
								array_mesh2 = surf_tool2.commit(array_mesh2)
		
		
			
	elif texturecount != 0:
		if texturesize1 == 148:
			var entrysizeExtra1=file.get_32()
		elif texturesize1 == 152:
			var entrysizeExtra1=file.get_32()
			var entrysizeExtra2=file.get_32()
		file.seek(texturesize1)
	
		var bna=[]
		var stack=[]
	
		var bone_names = []
	
		var iddx1
		
		var bonename = "%s" % iddx1
		
		var boncount = Skeleton3D.new()
		boncount.name = "GHG Armature"
		root_node.add_child(boncount)
		boncount.owner = root_node
		for i in range(BoneCount):
			boncount.add_bone("%s" % i)
		file.seek(bonesize1)
		for i in range(BoneCount):
			custom_seek(file,64,1)
			custom_seek(file,16,1)
			var parent_id = file.get_8()
			var s_idx : int=u8_to_s8(parent_id)
			custom_seek(file,15,1)
			boncount.set_bone_parent(i,s_idx)
		file.seek(bonesize3)
		
		var xposx=0
		var yposy=0
		var zposz=0
		var idx1a=-1
		
		var nposx=0
		var nposy=0
		var nposz=0
			
		for i in range(BoneCount):
			var ScaleX = file.get_float()
			var rotationz = file.get_float()
			var rotationy = file.get_float()
			var null1 = file.get_float()
			var nrotationz = file.get_float()
			var ScaleY = file.get_float()
			var rotationx = file.get_float()
			var nrotationy = file.get_float()
			var null2 = file.get_float()
			var nrotationx = file.get_float()
			var ScaleZ = file.get_float()
			var null3 = file.get_float()
			var posx = -file.get_float()
			var posy = -file.get_float()
			var posz = -file.get_float()
			var ScaleW = file.get_float()
			
			boncount.set_bone_pose_position(i, Vector3(ScaleX-ScaleX+posx*ScaleX,ScaleY-ScaleY+posy*ScaleY,ScaleZ-ScaleZ+-posz*ScaleZ))
		
			boncount.set_bone_pose_scale(i,Vector3(1,1,1))
			
		if texturecount == mateialcount:
			
			
			file.seek(0)
			
			file.seek(texturesize1)
			
			for i in range(texturecount):
				var imgsizelist1 = file.get_32()
				texsizee.append(imgsizelist1)
			file.seek(texsizee)
			if texturecount == 1:
				for i in range(1):
					var width1 = file.get_16()
					var typee1 = file.get_16()
					var height1 = file.get_16()
					var typee2 = file.get_16()
					var pitch = file.get_32()
					var flg1 = file.get_8()
					var flg2 = file.get_8()
					var flg3 = file.get_8()
					var flg4 = file.get_8()
					var sizz1 = file.get_32()
					var sizz2 = file.get_32()
					var imtype1 = file.get_32()
					var imtype2 = file.get_32()
					
					if imtype2 == 0:
						pass
					elif imtype2 !=0:
						var pad1=file.get_32()
						custom_seek(file,pad1,1)
						var imgrumble=file.get_8()
						var imgbrightness=file.get_8()
						var imgnull1=file.get_8()
						var imgflg01=file.get_8()
						custom_seek(file,8,1)
						var imgrumble2=file.get_8()
						var imgbrightness2=file.get_8()
						var imgnull2=file.get_8()
						var imgflg02=file.get_8()
						custom_seek(file,32,1)
						var comprwidth = file.get_32()
						var comprheight = file.get_32()
			
			file.seek(0)
				
		
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777731):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCountb = file.get_8()/2
					var flagsa1 = file.get_8()
					
					
					var faa=-3
					var fbb=-2
					var fcc=-1
					
					var faa1=-1
					var fbb1=-4
					var fcc1=-3
					var fdd1=-2
					
					var faces1=[]
					
					
					
					
					vertices3.resize(vertexCountb)
					faces3.resize(vertexCountb)
					uvs3.resize(vertexCountb)
					normals3.resize(vertexCountb)
					surf_tool3.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flagsa1 == int(109):
						flgidx+=1
						
						if flgidx <= int(256):
							if vertexCountb == int(3):
								for j in range(vertexCountb):
									var vx3 = file.get_16()
									var vy3 = file.get_16()
									var vz3 = file.get_16()
									var nz3 = file.get_16()
									var uvx3 = file.get_16()
									var uvy3 = file.get_16()
									var unkk = file.get_32()
									
									var signed_vx: int = u16_to_s16(vx3)
									var signed_vy: int = u16_to_s16(vy3)
									var signed_vz: int = u16_to_s16(vz3)
									
									var signed_uvx: int = u16_to_s16(uvx3)
									var signed_uvy: int = u16_to_s16(uvy3)
									
									var ssigned_vx = float(signed_vx)/4096
									var ssigned_vy = float(signed_vy)/4096
									var ssigned_vz = float(signed_vz)/4096
									
									var ssigned_uvx = float(signed_uvx)/4096
									var ssigned_uvy = float(signed_uvy)/4096
									
									var ssigned_vxx = snapped(ssigned_vx,0.001)
									var ssigned_vyy = snapped(ssigned_vy,0.001)
									var ssigned_vzz = snapped(ssigned_vz,0.001)
									
									
									
									
									surf_tool3.set_uv(Vector2(ssigned_uvx,-ssigned_uvy))
									surf_tool3.add_vertex(Vector3(ssigned_vxx,ssigned_vyy,-ssigned_vzz))
								custom_seek(file,78,1)
								var faceCount = file.get_8()
								var flg1 = file.get_8()
								if flg1 == int(110):
									if faceCount == int(1):
										for i in range(vertexCountb-2):
											faa+=1*3
											fbb+=1*3
											fcc+=1*3
											
											surf_tool3.add_index(faa)
											surf_tool3.add_index(fbb)
											surf_tool3.add_index(fcc)
									
									
								
							
									
								
						surf_tool3.generate_normals(true)
						surf_tool3.set_material(mat03)
					array_mesh3 = surf_tool3.commit(array_mesh3)
		
		
		
			file.seek(0)
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777475):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCount = file.get_8()
					var flags1 = file.get_8()
					
					var fa=-1
					var fb=0
					var fc=1
					
					
					var faa=-1
					var fbb=0
					var fcc=1
					
					
					
					
					vertices.resize(vertexCount)
					faces.resize(vertexCount)
					uvs.resize(vertexCount)
					normals.resize(vertexCount)
					surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
					
					#var faces = [[0,1,2]]
					if flags1 == int(108):
						flgidx+=1
						
						if flgidx <= int(256):
							for j in range(vertexCount):
								#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
								#var nz = file.get_float()
								var vx = file.get_float()
								var vy = file.get_float()
								var vz = file.get_float()
								var type4 = file.get_8()
								var value1 = file.get_8()
								var normalZ = file.get_16()
								
								var vx1 = vx
								var vy1 = vy
								var vz1 = vz
								
								var vxa = snapped(vx,0.001)
								var vya = snapped(vy,0.001)
								var vza = snapped(vz,0.001)
								
								if vx >= float(10000) and vy >= float(10000) and vz >= float(10000) or vx <= float(-10000) and vy <= float(-10000) and vz <= float(-10000):
									vx1-=vx1
									vy1-=vy1
									vz1-=vz1
								surf_tool.add_vertex(Vector3(vxa,vya,-vza))
								var type5 = type4==0
								fa+=1
								fb+=1
								fc+=1
								if type5:
									faces4=j+j+type4-type4-1+fa-j-j-1+j%2
									faces5=j-j+type4-type4+1+fb-2-1+j-j-j%2
									faces6=j+type4-type4+fc-j+2-4
									var a1=faces4
									var b1=faces5
									var c1=faces6

									surf_tool.add_index(a1)
									surf_tool.add_index(b1)
									surf_tool.add_index(c1)
									
						surf_tool.generate_normals(true)
						surf_tool.set_material(mat01)
					array_mesh = surf_tool.commit(array_mesh)
						
					
			
			
			file.seek(0)
			
			
			
			while file.get_position() < file.get_length():
				var Chunk = file.get_32()
				if Chunk == int(16777732):
					var unk01 = file.get_8()
					var unk02 = file.get_8()
					var vertexCounta = file.get_8()/2
					var flagsa1 = file.get_8()
					
					if vertexCounta:
					
					
						var faa=-1
						var fbb=0
						var fcc=1
						
						
						
						
						vertices2.resize(vertexCounta)
						faces2.resize(vertexCounta)
						uvs2.resize(vertexCounta)
						normals2.resize(vertexCounta)
						
						
						surf_tool2.begin(Mesh.PRIMITIVE_TRIANGLES)
						
						#var faces = [[0,1,2]]
						if flagsa1 == int(108):
							flgidx+=1
							
							if flgidx <= int(256):
								for j in range(vertexCounta):
									#vertices[i] = Vector3(file.get_float(),file.get_float(),file.get_float())
									#var nz = file.get_float()
									var vx2 = file.get_float()
									var vy2 = file.get_float()
									var vz2 = file.get_float()
									var brightness = file.get_float()
									var uvx2 = file.get_float()
									var uvy2 = file.get_float()
									var unkk = file.get_float()
									var type4 = file.get_8()
									var value1 = file.get_8()
									var normalZ = file.get_16()
									
									var vx1 = vx2
									var vy1 = vy2
									var vz1 = vz2
									
									var vx2a = snapped(vx2,0.001)
									var vy2a = snapped(vy2,0.001)
									var vz2a = snapped(vz2,0.001)
									if vx2 >= float(10000) and vy2 >= float(10000) and vz2 >= float(10000) or vx2 <= float(-10000) and vy2 <= float(-10000) and vz2 <= float(-10000):
										vx1-=vx1
										vy1-=vy1
										vz1-=vz1
									surf_tool2.set_color(Color(float(brightness),float(brightness),float(brightness),float(1)))
									surf_tool2.set_uv(Vector2(uvx2,-uvy2))
									surf_tool2.add_vertex(Vector3(vx2a,vy2a,-vz2a))
									var type5 = type4==0
									faa+=1
									fbb+=1
									fcc+=1
									if type5:
										faces4a=j+j+type4-type4-1+faa-j-j-1+j%2
										faces5a=j-j+type4-type4+1+fbb-2-1+j-j-j%2
										faces6a=j+type4-type4+fcc-j+2-4
										var a12=faces4a
										var b12=faces5a
										var c12=faces6a
				

										surf_tool2.add_index(a12)
										surf_tool2.add_index(b12)
										surf_tool2.add_index(c12)
										
								surf_tool2.generate_normals(true)
								surf_tool2.set_material(mat02)
								array_mesh2 = surf_tool2.commit(array_mesh2)
					
						
				#array_mesh3 = surf_tool3.commit(array_mesh3)
	
	
	immeediate_mesh2_.mesh = array_mesh2
	immeediate_mesh2_.name = "0x04020001 ghg 3"
	root_node.add_child(immeediate_mesh2_)
	immeediate_mesh2_.owner = root_node
	
	immeediate_mesh3_.mesh = array_mesh3
	immeediate_mesh3_.name = "0x03020001 ghg 2"
	root_node.add_child(immeediate_mesh3_)
	immeediate_mesh3_.owner = root_node
	
	immeediate_mesh_.mesh = array_mesh
	immeediate_mesh_.name = "0x03010001 ghg 1"
	root_node.add_child(immeediate_mesh_)
	immeediate_mesh_.owner = root_node
