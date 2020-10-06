cargo(tecnico, rogerio).
cargo(tecnico, ivone).
cargo(engenheiro, daniel).
cargo(engenheiro, isabel).
cargo(engenheiro, oscar). 
cargo(engenheiro, tomas).
cargo(engenheiro, ana).
cargo(supervisor, luis).
cargo(supervisor_chefe, sonia).
cargo(secretaria_exec, laura).
cargo(diretor, santiago).

chefiado_por(tecnico, engenheiro).
chefiado_por(engenheiro, supervisor).
chefiado_por(analista, supervisor).
chefiado_por(supervisor, supervisor_chefe).
chefiado_por(supervisor_chefe, director).
chefiado_por(secretaria_exec, director). 

% a) Qual é o cargo dos chefes de quem chefeia os técnicos?

% b) A Ivone chefeia algum técnico?

% c) Quem são os supervisores?

% d) Quem chefeia algum supervisor?

% e) Existe algum cargo chefiado pelo diretor que não seja o cargo da Carolina?