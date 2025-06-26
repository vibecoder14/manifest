//
//  SpecialDaysData.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import Foundation

struct SpecialDaysData {
    static let days: [SpecialDay] = [
        // Ocak
        SpecialDay(month: 1, day: 1, name: "Yılbaşı", theme: .universal),
        SpecialDay(month: 1, day: 6, name: "Epifani (İsa'nın vaftizi)", theme: .spiritual),
        SpecialDay(month: 1, day: 7, name: "Ortodoks Noel", theme: .spiritual),
        SpecialDay(month: 1, day: 13, name: "Hindu Lohri Festivali", theme: .cultural),
        SpecialDay(month: 1, day: 14, name: "Makar Sankranti (Hindu Güneş Festivali)", theme: .cultural),
        SpecialDay(month: 1, day: 15, name: "Dünya Kar Günü", theme: .fun),
        SpecialDay(month: 1, day: 19, name: "Timkat (Etiyopya Ortodoks Epifani)", theme: .cultural),
        // Note: Chinese New Year is variable
        SpecialDay(month: 1, day: 27, name: "Holokost Anma Günü", theme: .remembrance),
        SpecialDay(month: 1, day: 31, name: "Dünya Zevk Günü", theme: .fun),

        // Şubat
        SpecialDay(month: 2, day: 1, name: "İmbolc", theme: .lunar),
        SpecialDay(month: 2, day: 4, name: "Dünya Kanser Günü", theme: .universal),
        SpecialDay(month: 2, day: 12, name: "Darwin Günü", theme: .universal),
        SpecialDay(month: 2, day: 14, name: "Sevgililer Günü", theme: .fun),
        SpecialDay(month: 2, day: 15, name: "Lupercalia (Antik Roma)", theme: .cultural),
        SpecialDay(month: 2, day: 21, name: "Uluslararası Ana Dil Günü", theme: .universal),
        // Note: Purim is variable
        SpecialDay(month: 2, day: 29, name: "Artık Yıl Günü", theme: .fun),

        // Mart
        SpecialDay(month: 3, day: 1, name: "Dünya Kompliman Günü", theme: .fun),
        SpecialDay(month: 3, day: 8, name: "Dünya Kadınlar Günü", theme: .universal),
        SpecialDay(month: 3, day: 14, name: "Pi Günü", theme: .fun),
        SpecialDay(month: 3, day: 17, name: "Aziz Patrick Günü", theme: .cultural),
        SpecialDay(month: 3, day: 20, name: "Nevruz (Bahar Ekinoksu)", theme: .lunar),
        SpecialDay(month: 3, day: 21, name: "Dünya Down Sendromu Günü", theme: .universal),
        SpecialDay(month: 3, day: 22, name: "Dünya Su Günü", theme: .universal),
        // Note: Ramazan is variable
        SpecialDay(month: 3, day: 27, name: "Dünya Tiyatro Günü", theme: .universal),

        // Nisan
        SpecialDay(month: 4, day: 1, name: "Şaka Günü", theme: .fun),
        // Note: Paskalya is variable
        SpecialDay(month: 4, day: 7, name: "Dünya Sağlık Günü", theme: .universal),
        SpecialDay(month: 4, day: 13, name: "Songkran (Tayland Su Festivali)", theme: .cultural),
        SpecialDay(month: 4, day: 14, name: "Vaisakhi (Sikh ve Hindu Bahar Festivali)", theme: .cultural),
        SpecialDay(month: 4, day: 21, name: "Dünya Yaratıcılık ve Yenilikçilik Günü", theme: .universal),
        SpecialDay(month: 4, day: 22, name: "Dünya Günü", theme: .universal),
        SpecialDay(month: 4, day: 23, name: "Ulusal Egemenlik ve Çocuk Bayramı", theme: .national),
        // Note: Yom HaShoah is variable
        SpecialDay(month: 4, day: 30, name: "Walpurgis Gecesi", theme: .lunar),

        // Mayıs
        SpecialDay(month: 5, day: 1, name: "İşçi Bayramı", theme: .universal),
        SpecialDay(month: 5, day: 5, name: "Kodomo no Hi (Japonya Çocuklar Günü)", theme: .cultural),
        SpecialDay(month: 5, day: 6, name: "Hıdırellez", theme: .lunar),
        SpecialDay(month: 5, day: 9, name: "Avrupa Günü", theme: .universal),
        // Note: Mother's Day is variable
        SpecialDay(month: 5, day: 15, name: "Dünya Aile Günü", theme: .universal),
        SpecialDay(month: 5, day: 19, name: "Atatürk'ü Anma, Gençlik ve Spor Bayramı", theme: .national),
        // Note: Vesak is variable
        SpecialDay(month: 5, day: 29, name: "İstanbul'un Fethi", theme: .remembrance),
        
        // Haziran
        SpecialDay(month: 6, day: 1, name: "Dünya Çocuk Günü", theme: .universal),
        SpecialDay(month: 6, day: 5, name: "Dünya Çevre Günü", theme: .universal),
        SpecialDay(month: 6, day: 8, name: "Dünya Okyanus Günü", theme: .universal),
        // Note: Father's Day is variable
        SpecialDay(month: 6, day: 21, name: "Yaz Gündönümü", theme: .lunar),
        SpecialDay(month: 6, day: 21, name: "Uluslararası Yoga Günü", theme: .universal),
        SpecialDay(month: 6, day: 26, name: "Dünya Uyuşturucu ile Mücadele Günü", theme: .universal),

        // Temmuz
        SpecialDay(month: 7, day: 1, name: "Kabotaj Bayramı", theme: .national),
        SpecialDay(month: 7, day: 4, name: "ABD Bağımsızlık Günü", theme: .national),
        SpecialDay(month: 7, day: 7, name: "Tanabata", theme: .cultural),
        SpecialDay(month: 7, day: 15, name: "Demokrasi ve Milli Birlik Günü", theme: .national),
        SpecialDay(month: 7, day: 20, name: "Ay'a İlk İnsan Yolculuğu Anma Günü", theme: .universal),
        SpecialDay(month: 7, day: 23, name: "Dünya Balıkçılık Günü", theme: .universal),
        SpecialDay(month: 7, day: 30, name: "Dünya Arkadaşlık Günü", theme: .fun),

        // Ağustos
        SpecialDay(month: 8, day: 1, name: "Kız Arkadaşlar Günü", theme: .fun),
        SpecialDay(month: 8, day: 8, name: "Mutluluğu Kutlama Günü", theme: .fun),
        SpecialDay(month: 8, day: 13, name: "Solaklar Günü", theme: .fun),
        SpecialDay(month: 8, day: 15, name: "Rahatlama Günü", theme: .fun),
        SpecialDay(month: 8, day: 19, name: "Dünya Fotoğraf Günü", theme: .universal),
        SpecialDay(month: 8, day: 30, name: "Zafer Bayramı", theme: .national),

        // Eylül
        SpecialDay(month: 9, day: 1, name: "Emma Nutt Günü", theme: .fun),
        SpecialDay(month: 9, day: 5, name: "Peynirli Pizza Günü", theme: .fun),
        SpecialDay(month: 9, day: 8, name: "Özür Dileme Günü", theme: .fun),
        SpecialDay(month: 9, day: 13, name: "Pozitif Düşünme Günü", theme: .fun),
        SpecialDay(month: 9, day: 16, name: "Taş Toplama Günü", theme: .fun),
        SpecialDay(month: 9, day: 21, name: "Mini Golf Günü", theme: .fun),
        SpecialDay(month: 9, day: 23, name: "Sonbahar Ekinoksu", theme: .lunar),
        SpecialDay(month: 9, day: 27, name: "Teneke Kutu Ezme Günü", theme: .fun),
        SpecialDay(month: 9, day: 30, name: "Tarçınlı Sıcak İçecek Günü", theme: .fun),

        // Ekim
        SpecialDay(month: 10, day: 1, name: "Uluslararası Kahve Günü", theme: .fun),
        SpecialDay(month: 10, day: 4, name: "Dünya Hayvanları Koruma Günü", theme: .universal),
        SpecialDay(month: 10, day: 10, name: "Dünya Ruh Sağlığı Günü", theme: .universal),
        SpecialDay(month: 10, day: 16, name: "Dünya Gıda Günü", theme: .universal),
        SpecialDay(month: 10, day: 20, name: "Ay İzleme Günü", theme: .lunar),
        SpecialDay(month: 10, day: 29, name: "Cumhuriyet Bayramı", theme: .national),

        // Kasım
        SpecialDay(month: 11, day: 1, name: "Dünya Vegan Günü", theme: .universal),
        SpecialDay(month: 11, day: 10, name: "Atatürk'ü Anma Günü", theme: .remembrance),
        SpecialDay(month: 11, day: 11, name: "Bekarlar Günü", theme: .fun),
        SpecialDay(month: 11, day: 14, name: "Dünya Diyabet Günü", theme: .universal),
        SpecialDay(month: 11, day: 20, name: "Dünya Çocuk Hakları Günü", theme: .universal),
        SpecialDay(month: 11, day: 24, name: "Öğretmenler Günü", theme: .universal),
        SpecialDay(month: 11, day: 30, name: "St. Andrew Günü", theme: .cultural),

        // Aralık
        SpecialDay(month: 12, day: 1, name: "Kırmızı Elma Yeme Günü", theme: .fun),
        SpecialDay(month: 12, day: 5, name: "Ninja Günü", theme: .fun),
        SpecialDay(month: 12, day: 10, name: "İnsan Hakları Günü", theme: .universal),
        SpecialDay(month: 12, day: 21, name: "Kış Gündönümü", theme: .lunar),
        SpecialDay(month: 12, day: 25, name: "Noel", theme: .spiritual),
        SpecialDay(month: 12, day: 31, name: "Karar Verme Günü", theme: .fun)
    ]
} 