const baseURL = 'http://185.182.186.58:4001/api';
const getAllPharmacie = '$baseURL/pharmacie';
const getAllProduitByPharmacie = '$baseURL/produit/pharmacie';
const getAllVilleByPays = '$baseURL/ville/pays';
const getAllPays = '$baseURL/pays';
const getAllCommuneByVille = '$baseURL/commune/ville';
const getAllQuartierByCommune = '$baseURL/quartier/commune';
const getAllPharmacieQte = '$baseURL/pharmacie/qt';
const getAllproductList = '$baseURL/produit';

const serverError = "Aucune connexion";
const unauthorized = "Erreur de la base des données ";
const somethingwentwrong = "Quelque chose s'est mal passé, encore une fois";
