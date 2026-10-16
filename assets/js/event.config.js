/**
 * Configuração do evento — único lugar para clonar em outro projeto.
 * Carregado antes do script principal em index.html.
 */
window.GUGA_EVENTO = {
  siteHost: 'corrida-guga-35k.netlify.app',
  zapPhone: '554197333676',
  pixKey: '080.702.289-62',
  medalPriceBrl: 40,
  maxSlots: 40,
  /** Número reservado ao aniversariante / organizador */
  birthdaySlot: 1,
  /** Atualização da lista (ms) além do Realtime */
  pollIntervalMs: 20000,
  /** Largada — mês 0 = janeiro (10 = novembro) */
  eventStart: { year: 2026, month: 10, day: 20, hour: 7, minute: 30 }
};
