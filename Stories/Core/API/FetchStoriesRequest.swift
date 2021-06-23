//
//  Created by onsissond.
//

import Moya

struct FetchStoriesRequest: TargetType {

    var baseURL: URL {
        URL(string: "http://fakeurl/")!
    }

    var path: String {
        "v1/stories/config/"
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }

    var headers: [String: String]? {
        nil
    }

    var sampleData: Data {
        """
        [
          {
            "id": "1",
            "title": "Сочи",
            "subtitle": "Неделя за 50 000 ₽ на одного",
            "thumb": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F1.jpg?alt=media&token=d198093b-c8c6-44d5-9706-389ff7dbdca2",
            "publishDate": "2021-05-21",
            "expireDate": "2021-05-23",
            "pages": [
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F1.jpg?alt=media",
                "title": "Погода",
                "text": "Сухая солнечная погода обычно устанавливается в Сочи к середине апреля. Температура держится в районе 15 градусов тепла, но возможны пасмурные и дождливые дни, так что ветровка и непромокаемая обувь нужны обязательно."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F2.jpg?alt=media",
                "title": "Парк «Дендрарий»",
                "text": "Коллекция знаменитого сочинского дендрария насчитывает около 1800 деревьев, цветов и кустарников. Уделите прогулке по парку не менее трёх часов. Взрослый билет стоит 250 ₽, детский — 120 ₽; экскурсия на электромобиле — 150 ₽ с человека; билет на канатку между верхней и нижней частями парка — 350 ₽ взрослый и 200 ₽ детский."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F3.jpg?alt=media",
                "title": "Морской вокзал и Зимний театр",
                "text": "Главные архитектурные символы Сочи и идеальные образцы сталинского ампира. Прогулка от Морпорта до театра по улице Орджоникидзе займёт полчаса. По пути загляните в легендарную хинкальную «Белые ночи» (средник чек на человека — 1000 ₽ с напитком)."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F4.jpg?alt=media",
                "title": "Тисо-самшитовая роща",
                "text": "Для прогулки на природе отлично подойдёт тисо-самшитовая роща —  небольшой реликтовый лес с оборудованной тропой. Лучше всего зайти с главного входа и закончить каньоном «Чёртовы ворота», где можно искупаться и пообедать на базе отдыха. По пути увидите развалины Хостинской крепости VIII века. Прогулка по роще взрослым обойдётся в 300 ₽, детям до 14 лет — 150 ₽, до 7 лет — бесплатно."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F5.jpg?alt=media",
                "title": "Где жить",
                "text": "От отеля Allure of the Seа (от 4000 ₽/ночь) удобно добираться до тисо-самшитовой рощи, агурских водопадов, Орлиных скал, горы Ахун. Заказать экскурсию можно в отеле. Есть детский клуб, пинг-понг, бильярд, бассейн, столовая и буфет. До пляжа — 400 метров по тенистой аллее.\\n\\nБолее бюджетный вариант — GRACE O’DIN (от 1900 ₽/ночь) на Северной в пяти минутах от вокзала. До основных достопримечательностей отсюда можно добраться пешком."
              },
              {
                "type": "summary",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Fsochi%2F6.jpg?alt=media",
                "title": "Неделя в Сочи",
                "price": {
                  "title": "Бюджет поездки:",
                  "subtitle": "в расчете на одного человека",
                  "value": "50 000 ₽"
                },
                "period": {
                  "title": "Когда",
                  "value": "27 мар - 1 апр"
                },
                "deeplink": "https://www.google.com",
                "trip": {
                  "to": {
                    "type": "avia",
                    "title": "Уральские авиалинии от 4 156  Р",
                    "description": "туда 27 марта в 20:00"
                  },
                  "from": {
                    "type": "avia",
                    "title": "Уральские авиалинии от 5 000  Р",
                    "description": "обратно 1 апреля в 13:40"
                  }
                },
                "accommodation": {
                  "title": "11 000–24 000 ₽",
                  "description": "Неделя в двухместном номере с завтраком"
                },
                "nutrition": {
                  "title": "1000 ₽",
                  "description": "Средний чек (с напитком) в популярных недорогих кафе"
                },
                "entertainment": {
                  "title": "от 10 000 ₽",
                  "description": "Экскурсии, прогулки, развлечения, сувениры"
                }
              }
            ]
          },
          {
            "id": "2",
            "title": "Тула",
            "subtitle": "Выходные за 30 000 ₽ на одного",
            "thumb": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F1.jpg?alt=media",
            "publishDate": "2021-03-21",
            "expireDate": "2021-03-29",
            "pages": [
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F1.jpg?alt=media",
                "title": "Погода",
                "text": "В апреле в Туле бывает дождливо и пасмурно, температура выше 10 градусов поднимется только к концу месяца, так что прогулкам на свежем воздухе лучше предпочесть осмотр музеев и ужины в модных ресторанах."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F2.jpg?alt=media",
                "title": "Тульский Кремль",
                "text": "Крепость с 500-летней историей: здесь в Смутное время бояре присягали на верность Лжедмитрию I. В одной из крепостных стен есть лавки с тульскими пряниками, белёвской пастилой, суворовскими конфетами и, конечно, самоварами. Взрослый билет в Кремль стоит 250 ₽."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F3.jpg?alt=media",
                "title": "Креативное пространство «Искра»",
                "text": "Здесь есть кофейни и бары, дизайнерские магазинчики, барбершопы, чайные, коворкинг, хостел. В рюмочной Lil Pil на территории «Искры» подают настойки, зерновые дистилляты и креплёное вино. Ещё одна интересная локация— мясной ресторан пивоварни Salden’s, которая поставляет пиво по всей России (средний чек — 1500 ₽ на человека без алкоголя). "
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F4.jpg?alt=media",
                "title": "Поленово",
                "text": "Усадьба Василия Поленова, где хранятся его работы и личные вещи. В доме вы увидите эскиз знаменитой картины «Христос и грешница», а спустившись к Оке — меланхоличные пейзажи, которыми вдохновлялся художник. Музей находится в часе езды от Тулы, взрослый билет с экскурсией стоит 350 ₽, детский — 150 ₽."
              },
              {
                "type": "regular",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F5.jpg?alt=media",
                "title": "Где жить",
                "text": "Курортный спа-отель Grumant (от 4500 ₽/ночь с завтраком) находится рядом со знаменитой усадьбой Ясная Поляна, родовым имением Льва Толстого. В отеле есть бассейн, сауна и хаммам, боулинг; до центра Тулы — полчаса езды.\\n\\nВариант в той же ценовой категории, но в центре города — бутик-отель 11 Hotel & Garden. В 10 минутах ходьбы от отеля расположен «Ликёрка лофт» — ещё одно модное городское пространство с граффити, ресторанчиками и инстаграмными видами."
              },
              {
                "type": "summary",
                "image": "https://firebasestorage.googleapis.com/v0/b/mobile-transport-app.appspot.com/o/story%2Ftula%2F6.jpg?alt=media",
                "title": "Выходные в Туле",
                "price": {
                  "title": "Бюджет поездки:",
                  "subtitle": "в расчете на одного человека",
                  "value": "30 000 ₽"
                },
                "period": {
                  "title": "Когда",
                  "value": "27-28 марта"
                },
                "deeplink": "https://www.google.com",
                "trip": {
                  "to": {
                    "type": "train",
                    "title": "Ласточка от 1 171 ₽",
                    "description": "туда 27 марта в 08:47"
                  },
                  "from": {
                    "type": "train",
                    "title": "Ласточка-премиум от 1 220 ₽",
                    "description": "обратно 28 марта в 20:39"
                  }
                },
                "accommodation": {
                  "title": "13 500 ₽",
                  "description": "Три ночи в двухместном номере с завтраком"
                },
                "nutrition": {
                  "title": "2000–2500 ₽",
                  "description": "Средний чек (с алкоголем) в модных ресторанах города и пригорода"
                },
                "entertainment": {
                  "title": "до 5000 ₽",
                  "description": "Экскурсии, развлечения, шопинг и сувениры"
                }
              }
            ]
          },
          {
            "id": "3",
            "title": "Казань",
            "subtitle": "Царство янтаря на берегах бодрящего Балтийского моря",
            "thumb": "https://picsum.photos/id/10/200/300",
            "publishDate": "2021-03-27",
            "expireDate": "2021-04-02",
            "pages": [
              {
                "type": "regular",
                "image": "https://picsum.photos/id/10/720/1280",
                "title": "Весна в Калинграде",
                "text": "Суровое море, прекрасная прибалтийская природа и насыщенная история региона: каждая эпоха нашла в городе и окрестностях свое отражение.",
                "price": {
                  "title": "Бюджет",
                  "value": "от 55000 Р"
                },
                "period": {
                  "title": "Когда",
                  "value": "27 мар - 1 апр"
                }
              },
              {
                "type": "regular",
                "image": "https://picsum.photos/id/1000/720/1280",
                "title": "Остров Канта",
                "text": "Остров Канта, именовавшийся ранее островом Кнайпхоф, занимает место посреди реки Преголи. В лучшие свои дни город Кнайпхоф был центром судоходства и торговли, активно застраивался, располагал десятками дорог и сотнями домов и соединялся с материком пятью мостами.",
                "price": {
                  "title": "Бюджет",
                  "value": "55000"
                }
              },
              {
                "type": "regular",
                "image": "https://picsum.photos/id/900/720/1280",
                "title": "Форт «Дёнхофф»",
                "text": "Если вам по душе архитектурный стиль Кафедрального собора, обязательно посетите хотя бы несколько городских ворот и фортов. При наличии свободного времени прогуляйтесь по маршруту бывшего оборонительного кольца Кёнигсберга"
              },
              {
                "type": "summary",
                "image": "https://picsum.photos/id/1019/720/1280",
                "title": "Весна в Калинграде",
                "price": {
                  "title": "Бюджет поездки:",
                  "subtitle": "в расчете на одного человека",
                  "value": "55 000 ₽"
                },
                "period": {
                  "title": "Когда",
                  "value": "27 мар - 1 апр"
                },
                "deeplink": "https://www.google.com",
                "trip": {
                  "to": {
                    "type": "avia",
                    "title": "Аэрофлот от 5 000  Р",
                    "description": "обратно 28 марта в 18:30"
                  },
                  "from": {
                    "type": "avia",
                    "title": "Аэрофлот от 5 000  Р",
                    "description": "обратно 28 марта в 18:30"
                  }
                },
                "accommodation": {
                  "title": "18000",
                  "description": "7 ночей, двухместный номер с завтраком, исторический центр города"
                },
                "nutrition": {
                  "title": "1000",
                  "description": "Средний чек в лучших ресторанах города"
                },
                "entertainment": {
                  "title": "2000",
                  "description": "Прочие расходы на развлечения, билеты и экскурсии"
                }
              }
            ]
          }
        ]
        """.data(using: .utf8)!
    }
}
