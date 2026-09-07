package com.example.hotelreservation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*

/*
 * IMPORTANT:
 * For local Android emulator testing:
 *   API_BASE_URL = "http://10.0.2.2:3000/"
 *
 * After deploying the Node.js API, replace it with:
 *   API_BASE_URL = "https://YOUR-VERCEL-APP.vercel.app/"
 */
private const val API_BASE_URL = "http://10.0.2.2:3000/"

data class Guest(
    val name: String,
    val fatherName: String,
    val phone: String,
    val address: String,
    val cnic: String
)

data class Room(
    val room_id: Int,
    val room_number: Int,
    val capacity: Int,
    val status: String,
    val occupants: Int
)

data class ReservationRequest(
    val roomNumber: Int,
    val days: Int,
    val guests: List<Guest>
)

data class ReservationResponse(
    val message: String,
    val reservationId: Int?,
    val roomNumber: Int?,
    val days: Int?
)

interface HotelApi {
    @GET("api/rooms")
    suspend fun getRooms(): List<Room>

    @POST("api/reservations")
    suspend fun createReservation(
        @Body request: ReservationRequest
    ): ReservationResponse

    @PATCH("api/rooms/{roomNumber}/checkout")
    suspend fun checkout(@Path("roomNumber") roomNumber: Int): Map<String, String>
}

object ApiClient {
    val api: HotelApi = Retrofit.Builder()
        .baseUrl(API_BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(HotelApi::class.java)
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                HotelApp()
            }
        }
    }
}

@Composable
fun HotelApp() {
    val scope = rememberCoroutineScope()
    var rooms by remember { mutableStateOf<List<Room>>(emptyList()) }
    var message by remember { mutableStateOf("Loading rooms...") }
    var selectedRoom by remember { mutableStateOf<Int?>(null) }

    var guest1 by remember { mutableStateOf(Guest("", "", "", "", "")) }
    var guest2 by remember { mutableStateOf(Guest("", "", "", "", "")) }
    var daysText by remember { mutableStateOf("1") }

    fun loadRooms() {
        scope.launch {
            try {
                rooms = ApiClient.api.getRooms()
                message = "Rooms loaded."
            } catch (e: Exception) {
                message = "Connection error: ${e.message}"
            }
        }
    }

    LaunchedEffect(Unit) { loadRooms() }

    if (selectedRoom == null) {
        RoomListScreen(
            rooms = rooms,
            message = message,
            onRefresh = { loadRooms() },
            onSelectRoom = { selectedRoom = it }
        )
    } else {
        ReservationScreen(
            roomNumber = selectedRoom!!,
            daysText = daysText,
            onDaysChange = { daysText = it },
            guest1 = guest1,
            guest2 = guest2,
            onGuest1Change = { guest1 = it },
            onGuest2Change = { guest2 = it },
            onBack = { selectedRoom = null },
            onReserve = {
                scope.launch {
                    try {
                        val response = ApiClient.api.createReservation(
                            ReservationRequest(
                                roomNumber = selectedRoom!!,
                                days = daysText.toInt(),
                                guests = listOf(guest1, guest2)
                            )
                        )
                        message = response.message
                        selectedRoom = null
                        loadRooms()
                        guest1 = Guest("", "", "", "", "")
                        guest2 = Guest("", "", "", "", "")
                        daysText = "1"
                    } catch (e: Exception) {
                        message = "Reservation failed: ${e.message}"
                    }
                }
            }
        )
    }
}

@Composable
fun RoomListScreen(
    rooms: List<Room>,
    message: String,
    onRefresh: () -> Unit,
    onSelectRoom: (Int) -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp)
    ) {
        Text("Hotel Reservation System", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(8.dp))
        Text("50 rooms • maximum 2 guests per room")
        Spacer(Modifier.height(8.dp))
        Text(message)

        Row {
            Button(onClick = onRefresh) { Text("Refresh") }
        }

        Spacer(Modifier.height(8.dp))

        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            items(rooms) { room ->
                Card(modifier = Modifier.fillMaxWidth()) {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text("Room ${room.room_number}")
                            Text("${room.status} • ${room.occupants}/${room.capacity} guests")
                        }
                        if (room.status == "AVAILABLE") {
                            Button(onClick = { onSelectRoom(room.room_number) }) {
                                Text("Reserve")
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ReservationScreen(
    roomNumber: Int,
    daysText: String,
    onDaysChange: (String) -> Unit,
    guest1: Guest,
    guest2: Guest,
    onGuest1Change: (Guest) -> Unit,
    onGuest2Change: (Guest) -> Unit,
    onBack: () -> Unit,
    onReserve: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp)
    ) {
        Row(horizontalArrangement = Arrangement.SpaceBetween) {
            Text("Reserve Room $roomNumber", style = MaterialTheme.typography.headlineSmall)
            TextButton(onClick = onBack) { Text("Back") }
        }

        OutlinedTextField(
            value = daysText,
            onValueChange = onDaysChange,
            label = { Text("Days") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(Modifier.height(10.dp))
        Text("Guest 1", style = MaterialTheme.typography.titleMedium)
        GuestFields(guest1, onGuest1Change)

        Spacer(Modifier.height(10.dp))
        Text("Guest 2", style = MaterialTheme.typography.titleMedium)
        GuestFields(guest2, onGuest2Change)

        Spacer(Modifier.height(12.dp))
        Button(
            onClick = onReserve,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Confirm Reservation")
        }
    }
}

@Composable
fun GuestFields(guest: Guest, onChange: (Guest) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        OutlinedTextField(
            value = guest.name,
            onValueChange = { onChange(guest.copy(name = it)) },
            label = { Text("Name") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = guest.fatherName,
            onValueChange = { onChange(guest.copy(fatherName = it)) },
            label = { Text("Father Name") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = guest.phone,
            onValueChange = { onChange(guest.copy(phone = it)) },
            label = { Text("Phone") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = guest.address,
            onValueChange = { onChange(guest.copy(address = it)) },
            label = { Text("Address") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = guest.cnic,
            onValueChange = { onChange(guest.copy(cnic = it)) },
            label = { Text("CNIC (use dummy data for demo)") },
            modifier = Modifier.fillMaxWidth()
        )
    }
}
