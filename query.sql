SELECT 
	titre.id,
	titre.nmtit nom,
	t_type.nom AS type,
	statut.nom_etatj statut,
	travaux.nom_etatt travaux,
	json_build_object(
    'principales', substances,
    'connexes', null
  ) substances,
	json_build_object('durée', titre.duree, 'début', titre.datmo) validité,
	emprises.nom_locmer emprises,
  titre.surf surface,
  titulaires_json titulaires,
	json_build_object('statut', statuts) démarches 
FROM 
	titres_deb.m_t_titre titre
LEFT JOIN
	titres_deb.m_r_typ t_type
	ON 
		titre.typtit = t_type.id
LEFT JOIN
	titres_deb.m_r_etatj statut
	ON 
		titre.etatj = statut.id
LEFT JOIN
	titres_deb.m_r_etatt travaux
	ON 
		titre.etatt = travaux.id
LEFT JOIN
	(SELECT
		sub_join.id_tit sub_titre_id,
		json_agg(sub.nom_sub) substances
	FROM
		titres_deb.m_t_sub sub_join
	INNER JOIN
		titres_deb.m_r_sub sub
		ON
			sub.id = sub_join.id_sub
	GROUP BY
		sub_join.id_tit
	) subs
	ON
		titre.id = sub_titre_id
LEFT JOIN
	titres_deb.m_r_locmer emprises
	ON 
    CAST(emprises.id AS text) = titre.locmer 
LEFT JOIN
  (SELECT
    titulaire.id_tit titulaire_titre_id,
    json_agg(titulaire.id) titulaires_json
  FROM
    titres_deb.m_t_titu titulaire
  GROUP BY
    titulaire.id_tit
  ) titu
	ON 
    titulaire_titre_id = titre.id
LEFT JOIN
	(SELECT
		stat.id_tit statut_titre_id,
		json_agg(json_build_object(
			'id', stat.id,
			'type', statut_type.typ_aff,
			'statut', statut_etat.etat_aff,
      'description', stat.nom,
			'dates', json_build_object(
				'ouverture', stat.dat_a_ouv,
				'fermeture', stat.dat_a_fer 
			),
			'documents', documents_json
		)) statuts
	FROM
		titres_deb.m_t_aff stat
	LEFT JOIN
		titres_deb.m_r_typaff statut_type
		ON
			statut_type.id = stat.a_typ
	LEFT JOIN
		titres_deb.m_r_etataff statut_etat
		ON
			statut_etat.id = stat.a_etat
	LEFT JOIN
		(SELECT
			evt.id_aff evt_id_aff,
			json_agg(json_build_object(
        'id', evt.id,
        'nom', evt_type.evt_nom,
        'date', evt.dat,
        'acte', false,
        'public', false,
        'organisme', null,
        'fichier', file_json,
        'commentaire', evt.obs,
        'étiquettes', null
      )) documents_json
		FROM
      titres_deb.m_t_evt evt
    LEFT JOIN
      titres_deb.m_r_evt evt_type
      ON
        evt_type.id = evt.cod_evt
    INNER JOIN
      (SELECT
        file.id_evt file_id_evt,
        json_build_object(
          'id', file.id,
          'url', file.url,
          'taille', file.taille,
          'type', file.exten 
        ) file_json
      FROM
        titres_deb.m_t_docu file
      ) fils
      ON
        file_id_evt = evt.id
		GROUP BY
			evt.id_aff
		) docs
		ON
			evt_id_aff = stat.id
	GROUP BY
		stat.id_tit
	) sta
	ON
		titre.id = statut_titre_id