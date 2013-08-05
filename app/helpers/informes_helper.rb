module InformesHelper


#[['Authors', ['Jose', 'Carlos']], ['General', ['Bob', 'John']]]
def get_funcionarios_group
	result = {}
	funcionario = Funcionario.all

	funcionario.each do |r|
		result[CargoEstructura.find(r.cargo_estructura_id).cargo.nombre  + " " + CargoEstructura.find(r.cargo_estructura_id).estructura.nombre] ||= {}
		result[CargoEstructura.find(r.cargo_estructura_id).cargo.nombre  + " " + CargoEstructura.find(r.cargo_estructura_id).estructura.nombre][r.nombre_completo] = r.id
	end

	return result
end

end
