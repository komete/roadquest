# Jeux de données #

User.create!(nom: 'GUILLAUME', prenom: 'Rémi', poste: '1', email: 'remi.guillaume.montreal@gmail.com',
                     codeEmploye: 'GUIR23078602', telephone: '438-876-0843', username: 'komete', administrateur: true,
             password: 'admin1', password_confirmation: 'admin1', verified: true, verified_at: Time.zone.now)
User.create!(nom: 'SAWADOGO', prenom: 'Fayçal', poste: '1', email: 'faycalsawadogo@gmail.com',
                     codeEmploye: 'SAWA23098900', telephone: '438-935-8129', username: 'Gangsta', administrateur: true,
              password: 'admin2', password_confirmation: 'admin2', verified: true, verified_at: Time.zone.now)
User.create!(nom: 'BRIEN-LEJEUNE', prenom: 'Stéphanie', poste: '1', email: 'stephanielejeune41@gmail.com',
              codeEmploye: 'BRIS01579306', telephone: '514-218-7720', username: 'Superwoman', administrateur: true,
              password: 'admin3', password_confirmation: 'admin3', verified: true, verified_at: Time.zone.now)