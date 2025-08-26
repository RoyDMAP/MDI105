//
//  api.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//


import SwiftUI

func getDefaultBooks() -> [Book] {
    return [
        Book(
            title: "The Fellowship of the Ring",
            author: "J.R.R. Tolkien",
            image: "Pic1",
            description: "The first volume of The Lord of the Rings tells of the fateful power of the One Ring. It begins a magnificent tale of adventure that will plunge the members of the Fellowship of the Ring into a perilous quest and set the stage for the ultimate clash between the powers of good and evil.",
            rating: 4,
            review: "This is a great book",
            status: .notStarted,
            genre: .classic,
            isFavorite: false
        ),
        Book(
            title: "The Two Towers",
            author: "J.R.R. Tolkien",
            image: "Pic2",
            description: "The second volume in The Lord of the Rings tells of the Fellowship's adventures as they continue their quest to destroy the Ring and defeat the Dark Lord Sauron. Frodo and Sam continue towards Mordor to destroy the Ring, unaware of the tragedy that has befallen their companions.",
            rating: 5,
            review: "Amazing book",
            status: .finished,
            genre: .fantasy,
            isFavorite: true
        ),
        Book(
            title: "Moby Dick",
            author: "Herman Melville",
            image: "Pic5",
            description: "A young seaman joins the crew of the fanatical Captain Ahab in pursuit of the white whale Moby Dick",
            rating: 4,
            review: "Amazing book",
            status: .notStarted,
            genre: .classic,
            isFavorite: false
        ),
        Book(
            title: "Gulliver's Travels",
            author: "Jonathan Swift",
            image: "Pic6",
            description: "An Englishman becomes shipwrecked in various lands on four different voyages",
            rating: 4,
            review: "A must read",
            status: .notStarted,
            genre: .classic,
            isFavorite: false
        ),
        Book(
            title: "The Art of the Hobbit",
            author: "J.R.R. Tolkien",
            image: "Pic4",
            description: "This includes over one hundred sketches, drawings, paintings, maps, and plans, many of which were preliminary or experimental versions and are published here for the first time, some in color. The book offers a unique look into Tolkien's creative process and how he visualized the world of The Hobbit.",
            rating: 5,
            review: "Amazing book",
            status: .notStarted,
            genre: .fantasy, // Changed from .terror to .fantasy (more appropriate)
            isFavorite: false
        ),
        Book(
            title: "Final Fantasy VII Remake: Traces of Two Pasts",
            author: "Kazushige Nojima",
            image: "Pic7",
            description: "This novel in two parts delves into the pasts of Aerith Gainsborough and Tifa Lockhart, the beloved heroines of Final Fantasy VII.",
            rating: 5,
            review: "Amazing book",
            status: .notStarted,
            genre: .fantasy,
            isFavorite: false
        ),
        Book(
            title: "Sleeping Beauties: A Graphic Novel",
            author: "Stephen King",
            image: "Pic8",
            description: "A bizarre sleeping sickness, called Aurora, has fallen over the world. Its victims can't wake up. And all of them are women. As nations fall into chaos, those women still awake take desperate measures to stay that way, and men everywhere begin to give in to their darkest impulses. Meanwhile, in the small town of Dooling, a mysterious woman has walked out of the woods; she calls herself Eve and leaves a trail of carnage in her wake. Strangest of all, she's the only woman who can wake up.",
            rating: 5,
            review: "Twist and turns",
            status: .notStarted,
            genre: .terror, // Changed from .dystopian to .terror (horror genre)
            isFavorite: false
        ),
        Book(
            title: "The Return of the King",
            author: "J.R.R. Tolkien",
            image: "Pic3",
            description: "The final volume of The Lord of the Rings, tells of the opposing strategies of the wizard Gandalf and the Dark Lord Sauron, the final battle, and the ending of the War of the Ring in the Battle of the Pelennor Fields and at the Black Gate.",
            rating: 5,
            review: "This is the best book",
            status: .finished,
            genre: .fantasy, // Changed from .dystopian to .fantasy
            isFavorite: true
        )
    ]
}

#Preview {
    ContentView()
}
