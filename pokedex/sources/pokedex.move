module pokedex::pokedex {
    // === Seccion de librerias (o Imports) ===
    use std::string;
    use sui::vec_map;
    //use sui::tx_context::sender;


    // === Seccion de posibles errores para prevenir (o Errors) ===
    #[error] const EYA_EXISTE: u64 = 1;
    #[error] const ENO_ENCONTRADO: u64 = 2;

    // === Funciones principales (funciones tipo Structs) ===
    public struct Pokedex has key, store {
        id: UID,
        nombre: string::String,
        pokemons: vec_map::VecMap<u16, Pokemon>,
    }

    public struct Pokemon has store, drop {
        numero: u16,
        nombre: string::String,
        region: string::String,
        tipos: vector<string::String>,
        descripcion: string::String,
        peso: u64,
        altura: u64,
        habilidades: vector<string::String>,
        estadisticas: vector<u8>,
        cadena_evolutiva: vector<string::String>,
        ubicaciones: vector<string::String>,
        movimientos_nivel: vector<string::String>,
        movimientos_mt: vector<string::String>,
        movimientos_huevo: vector<string::String>,
    }


    // === Funciones públicas ===

    // Funcion para crea una nueva Pokedex
    public fun crear_pokedex(nombre: string::String, ctx: &mut TxContext): Pokedex {
        Pokedex {
            id: object::new(ctx),
            nombre,
            pokemons: vec_map::empty(),
        }
    }

    // Funcion para agrega un Pokemon a la Pokedex
    public fun agregar_pokemon(
        pokedex: &mut Pokedex,
        numero: u16,
        nombre: string::String,
        region: string::String,
        tipos: vector<string::String>,
        descripcion: string::String,
        peso: u64,
        altura: u64,
        habilidades: vector<string::String>,
        estadisticas: vector<u8>,
        cadena_evolutiva: vector<string::String>,
        ubicaciones: vector<string::String>,
        movimientos_nivel: vector<string::String>,
        movimientos_mt: vector<string::String>,
        movimientos_huevo: vector<string::String>){
            assert!(!vec_map::contains(&pokedex.pokemons, &numero), EYA_EXISTE);
            let pokemon = Pokemon{
                numero,
                nombre,
                region,
                tipos,
                descripcion,
                peso,
                altura,
                habilidades,
                estadisticas,
                cadena_evolutiva,
                ubicaciones,
                movimientos_nivel,
                movimientos_mt,
                movimientos_huevo,
            };
            vec_map::insert(&mut pokedex.pokemons, numero, pokemon);
        }

    // Funcion para elimina un Pokemon de la Pokedex
    public fun eliminar_pokemon(pokedex: &mut Pokedex, numero: u16) {
        assert!(vec_map::contains(&pokedex.pokemons, &numero), ENO_ENCONTRADO);
        let (_key, _pokemon) = vec_map::remove(&mut pokedex.pokemons, &numero);
    }

    // Funcion para busca un Pokémon por región
    public fun buscar_por_region(pokedex: &Pokedex, region_buscada: string::String): string::String {
        let mut resultado = string::utf8(b"Pokemon de la region ");
        string::append(&mut resultado, region_buscada);
        string::append(&mut resultado, string::utf8(b":\n"));

        let keys = vec_map::keys(&pokedex.pokemons);
        let mut i = 0;
        while (i < vector::length(&keys)) {
            let key = vector::borrow(&keys, i);
            let pokemon = vec_map::get(&pokedex.pokemons, key);
            if (pokemon.region == region_buscada) {
                string::append(&mut resultado, pokemon.nombre);
                string::append(&mut resultado, string::utf8(b"\n"));
            };
            i = i + 1;
        };
        resultado
    }

    // Funcion para busca un Pokémon por tipo
    public fun buscar_por_tipo(pokedex: &Pokedex, tipo_buscado: string::String): string::String {
        let mut resultado = string::utf8(b"Pokemon por tipo ");
        string::append(&mut resultado, tipo_buscado);
        string::append(&mut resultado, string::utf8(b"\n"));

        let keys = vec_map::keys(&pokedex.pokemons);
        let mut i = 0;
        while (i < vector::length(&keys)) {
            let key = vector::borrow(&keys, i);
            let pokemon = vec_map::get(&pokedex.pokemons, key);
            
            let mut j = 0;
            while (j < vector::length(&pokemon.tipos)) {
                let tipo_actual = vector::borrow(&pokemon.tipos, j);
                if (*tipo_actual == tipo_buscado) {
                    string::append(&mut resultado, pokemon.nombre);
                    string::append(&mut resultado, string::utf8(b"\n"));
                    break
                };
                j = j + 1;
            };
            i = i + 1;
        };
        resultado
    }

    // Funcion que obtiene el número de Pokémon en la Pokedex
    public fun cantidad_pokemon(pokedex: &Pokedex): u64 {
        vec_map::length(&pokedex.pokemons) as u64
    }

    // Funcion para verifica si un Pokémon existe en la Pokedex
    public fun existe_pokemon(pokedex: &Pokedex, numero: u16): bool {
        vec_map::contains(&pokedex.pokemons, &numero)
    }
}

