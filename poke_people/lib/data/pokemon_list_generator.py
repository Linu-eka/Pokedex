import requests
import json

def get_pokemon_generation(pokemon_id):
    """Determine the generation based on Pokémon ID ranges."""
    if 1 <= pokemon_id <= 151:
        return 1
    elif 152 <= pokemon_id <= 251:
        return 2
    elif 252 <= pokemon_id <= 386:
        return 3
    elif 387 <= pokemon_id <= 493:
        return 4
    elif 494 <= pokemon_id <= 649:
        return 5
    elif 650 <= pokemon_id <= 721:
        return 6
    elif 722 <= pokemon_id <= 809:
        return 7
    elif 810 <= pokemon_id <= 905:
        return 8
    elif 906 <= pokemon_id <= 1025:
        return 9
    else:
        return None  # For future-proofing

def fetch_all_pokemon():
    """Fetch all 1025 core Pokémon with their details."""
    base_url = "https://pokeapi.co/api/v2/pokemon-species?limit=1025"
    response = requests.get(base_url)
    species_data = response.json()["results"]
    
    pokemon_list = []
    for species in species_data:
        pokemon_id = int(species["url"].split("/")[-2])
        generation = get_pokemon_generation(pokemon_id)
        name = species["name"].capitalize()
        image_url = f"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{pokemon_id}.png"
        
        pokemon_list.append({
            "id": pokemon_id,
            "generation": generation,
            "name": name,
            "imageUrl": image_url,
        })
    
    return pokemon_list

# Generate the list
all_pokemon = fetch_all_pokemon()

# Save to a JSON file
with open("pokemon_list.json", "w") as f:
    json.dump(all_pokemon, f, indent=2)

print(f"Generated list of {len(all_pokemon)} Pokémon. Saved to 'pokemon_list.json'.")