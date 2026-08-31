#!/usr/bin/env python3
"""
Downloads the complete Qur'an (Uthmani Hafs text + Saheeh International
translation) from the trusted quran.com API and writes a bundled asset JSON.

Source data is the standard Tanzil Uthmani text and Saheeh International
translation — the same widely trusted sources already used in the app.
Quranic text is fixed and trusted; it is never generated or altered.
"""
import json
import re
import sys
import time
import urllib.request

API = "https://api.quran.com/api/v4"
TRANSLATION_ID = 20  # Saheeh International


def fetch(url, tries=3):
    for i in range(tries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "AyahPath/1.0"})
            with urllib.request.urlopen(req, timeout=30) as r:
                return json.loads(r.read().decode("utf-8"))
        except Exception as e:
            if i == tries - 1:
                raise
            time.sleep(1.5)


def clean_translation(text):
    # Remove quran.com footnote markup: <sup foot_note=...>...</sup>
    text = re.sub(r"<sup[^>]*>.*?</sup>", "", text)
    text = text.replace("’", "'").replace("“", '"').replace("”", '"')
    return text.strip()


def main():
    # Fetch chapter list to know how many surahs.
    chapters = fetch(f"{API}/chapters?language=en")
    surahs = chapters["chapters"]
    print(f"Fetching {len(surahs)} surahs...")

    result = []
    for ch in surahs:
        num = ch["id"]
        verses = fetch(
            f"{API}/verses/by_chapter/{num}?fields=text_uthmani&translations={TRANSLATION_ID}&per_page=300"
        )
        ayahs = []
        for v in verses["verses"]:
            trans = v.get("translations") or [{}]
            ayahs.append(
                {
                    "n": v["verse_number"],
                    "ar": v.get("text_uthmani", "").strip(),
                    "en": clean_translation(trans[0].get("text", "")),
                }
            )
        result.append(
            {
                "number": num,
                "name": ch["name_arabic"],
                "englishName": ch["name_simple"],
                "englishNameTranslation": ch["translated_name"]["name"],
                "revelationPlace": ch["revelation_place"],
                "ayahCount": ch["verses_count"],
                "ayahs": ayahs,
            }
        )
        print(f"  {num:3d} {ch['name_simple']:20s} {ch['verses_count']:3d} ayahs")

    out = {
        "source": "Tanzil Uthmani Hafs + Saheeh International (quran.com API)",
        "version": "1.0.0",
        "surahs": result,
    }
    with open("assets/quran/quran.json", "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, separators=(",", ":"))
    print(f"\nWrote assets/quran/quran.json")
    print(f"Total ayahs: {sum(s['ayahCount'] for s in result)}")


if __name__ == "__main__":
    main()
