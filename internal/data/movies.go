package data

import (
	"time"
)

type Movie struct {
	ID        int64     `json:"id"`
	CreatedAt time.Time `json:"-"` //- to ommit in the json response
	Title     string    `json:"title"`
	Year      int32     `json:"year,omitempty"` // omitempty directive, use json:",omitempty" if you want to keep the key name but omit if empty
	Runtime   int32     `json:"runtime,omitempty""`
	Genres    []string  `json:"genres,omitempty""`
	Version   int32     `json:"version"`
}
